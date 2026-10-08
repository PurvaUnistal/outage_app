import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/Image/image_stamp_helper.dart';
import 'package:outage_app/Utils/common_widgets/Location/location_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Camera / Gallery / Document pick karta hai aur image par location stamp lagata hai.
///
/// Usage:
///   final file = await MediaPickerHelper.showPickerOptions(context: context);
class MediaPickerHelper {
  MediaPickerHelper._();

  static const List<String> imageExt = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedExt = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'];

  static const int _quality = 60;
  static const int _maxWidth = 950;
  static const int _maxHeight = 1200;

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  /// File ka extension (lowercase, bina dot ke). Extension na ho to empty string.
  static String extensionOf(String path) {
    final name = path.split(Platform.pathSeparator).last;
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return '';
    return name.substring(dot + 1).toLowerCase();
  }

  static bool isImage(File file) => imageExt.contains(extensionOf(file.path));

  // ===========================================================================
  // BOTTOM SHEET — Camera / Gallery / Document choose karo
  // ===========================================================================
  static Future<File?> showPickerOptions({
    required BuildContext context,
    bool allowCamera = true,
    bool allowGallery = true,
    bool allowDocuments = true,
  }) async {
    final _PickSource? choice = await showModalBottomSheet<_PickSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            if (allowCamera)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () => Navigator.pop(ctx, _PickSource.camera),
              ),
            if (allowGallery)
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () => Navigator.pop(ctx, _PickSource.gallery),
              ),
            if (allowDocuments)
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text("Upload Document"),
                subtitle: const Text("PDF, DOC, DOCX, JPG, PNG"),
                onTap: () => Navigator.pop(ctx, _PickSource.document),
              ),
          ],
        ),
      ),
    );

    if (choice == null || !context.mounted) return null;

    switch (choice) {
      case _PickSource.camera:
        return cameraCapture(context: context);
      case _PickSource.gallery:
        return galleryCapture(context: context);
      case _PickSource.document:
        return documentPicker(context: context);
    }
  }

  // ===========================================================================
  // CAMERA
  // ===========================================================================
  static Future<File?> cameraCapture({required BuildContext context}) async {
    try {
      // 1. Camera khulne se PEHLE location confirm karo
      if (!await LocationHelper.ensureLocationReady(context)) {
        _showError(context, "Location is required to take a photo.");
        return null;
      }

      // 2. Camera permission
      if (!context.mounted) return null;
      if (!await _ensureCameraPermission(context)) return null;

      // 3. Photo lo
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: _quality,
        maxHeight: _maxHeight.toDouble(),
        maxWidth: _maxWidth.toDouble(),
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo == null) return null; // user ne cancel kiya

      // 4. Stamp lagao
      if (!context.mounted) return null;
      return await _stampWithLocation(context, File(photo.path));
    } on PlatformException catch (e) {
      if (kDebugMode) print("Camera platform error: ${e.code} ${e.message}");
      if (!context.mounted) return null;
      if (e.code == 'camera_access_denied') {
        await _showSettingsDialog(
          context,
          title: "Camera permission needed",
          message: "Camera access is turned off. Please enable it in Settings to take photos.",
        );
      } else {
        _showError(context, "Unable to open camera. Please try again.");
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Camera error: $e");
      _showError(context, "Unable to open camera. Please try again.");
      return null;
    }
  }

  // ===========================================================================
  // GALLERY
  // (Permission ki zarurat nahi — Android Photo Picker / iOS PHPicker
  //  image_picker khud handle karta hai)
  // ===========================================================================
  static Future<File?> galleryCapture({required BuildContext context}) async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: _quality,
        maxHeight: _maxHeight.toDouble(),
        maxWidth: _maxWidth.toDouble(),
      );
      if (photo == null) return null;

      // Kuch phones gallery se HEIC/WEBP de dete hain — JPG/PNG hi allow karo
      final ext = extensionOf(photo.path);
      if (!imageExt.contains(ext)) {
        if (!context.mounted) return null;
        _showError(context, "Only JPG, JPEG, PNG images are allowed.");
        return null;
      }

      if (!context.mounted) return null;
      if (!await LocationHelper.ensureLocationReady(context)) {
        _showError(context, "Location is required to add a photo.");
        return null;
      }

      if (!context.mounted) return null;
      return await _stampWithLocation(context, File(photo.path));
    } on PlatformException catch (e) {
      if (kDebugMode) print("Gallery platform error: ${e.code} ${e.message}");
      if (!context.mounted) return null;
      if (e.code == 'photo_access_denied') {
        await _showSettingsDialog(
          context,
          title: "Photos permission needed",
          message: "Photo access is turned off. Please enable it in Settings to choose images.",
        );
      } else {
        _showError(context, "Unable to pick image. Please try again.");
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Gallery error: $e");
      _showError(context, "Unable to pick image. Please try again.");
      return null;
    }
  }

  // ===========================================================================
  // DOCUMENT (JPG / PNG / PDF / DOC / DOCX)
  // (System file picker use hota hai — permission ki zarurat nahi)
  // ===========================================================================
  static Future<File?> documentPicker({required BuildContext context}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExt,
      );
      final path = result?.files.single.path;
      if (path == null) return null;

      final file = File(path);
      final ext = extensionOf(file.path);

      // Kuch platforms filter ignore karte hain — safety check
      if (!allowedExt.contains(ext)) {
        if (!context.mounted) return null;
        _showError(context, "Only JPG, JPEG, PNG, PDF, DOC, DOCX files are allowed.");
        return null;
      }

      // PDF / DOC / DOCX par stamp nahi lagta — seedha return
      if (!imageExt.contains(ext)) return file;

      // Image hai to location + compress + stamp
      if (!context.mounted) return null;
      if (!await LocationHelper.ensureLocationReady(context)) {
        _showError(context, "Location is required to add a photo.");
        return null;
      }

      // File picker compress nahi karta — camera/gallery jaisa size rakho
      final compressed = await _compress(file);

      if (!context.mounted) return null;
      return await _stampWithLocation(context, compressed);
    } catch (e) {
      if (kDebugMode) print("Document picker error: $e");
      _showError(context, "Unable to pick file. Please try again.");
      return null;
    }
  }

  // ===========================================================================
  // CAMERA PERMISSION
  // ===========================================================================
  static Future<bool> _ensureCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) return true;

    status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) return true;

    if (!context.mounted) return false;

    if (status.isPermanentlyDenied || status.isRestricted) {
      await _showSettingsDialog(
        context,
        title: "Camera permission needed",
        message: "Camera access is turned off. Please enable it in Settings to take photos.",
      );
    } else {
      _showError(context, "Camera permission is required to take a photo.");
    }
    return false;
  }

  static Future<void> _showSettingsDialog(
      BuildContext context, {
        required String title,
        required String message,
      }) async {
    final open = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
    if (open == true) await openAppSettings();
  }

  // ===========================================================================
  // IMAGE COMPRESS (sirf document picker wali images ke liye)
  // ===========================================================================
  static Future<File> _compress(File file) async {
    try {
      final targetPath =
          '${file.parent.path}/cmp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: _quality,
        minWidth: _maxWidth,
        minHeight: _maxHeight,
        format: CompressFormat.jpeg,
      );
      return result != null ? File(result.path) : file;
    } catch (e) {
      if (kDebugMode) print("Compress error: $e");
      return file; // compress fail ho to original hi use karo
    }
  }

  // ===========================================================================
  // LocationHelper se location + address lekar stamp lagao
  // ===========================================================================
  static Future<File?> _stampWithLocation(BuildContext context, File file) async {
    try {
      final location = await LocationHelper.getLocation(context: context);
      final position = LocationHelper.position;

      if (location == null || position == null) {
        _showError(context, "Unable to get location. Please try again.");
        return null;
      }

      // Fake GPS block
      if (position.isMocked) {
        _showError(context, "Fake location detected. Please turn off mock location apps.");
        return null;
      }

      return await ImageStampHelper.stamp(
        file: file,
        latitude: position.latitude,
        longitude: position.longitude,
        address: LocationHelper.currentAddress,
      );
    } catch (e) {
      if (kDebugMode) print("Stamp error: $e");
      _showError(context, "Failed to process image. Please try again.");
      return null;
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      Utils.errorSnackBar(msg: message, context: context);
    }
  }
}

enum _PickSource { camera, gallery, document }

// =============================================================================
// PREVIEW — image ho to image dikhao, PDF/DOC ho to icon + naam
// =============================================================================
class PickedFilePreview extends StatelessWidget {
  const PickedFilePreview({
    super.key,
    required this.file,
    this.height = 200,
    this.onRemove,
  });

  final File file;
  final double height;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ext = MediaPickerHelper.extensionOf(file.path);
    final name = file.path.split(Platform.pathSeparator).last;

    final Widget content = MediaPickerHelper.isImage(file)
        ? ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        file,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Center(child: Icon(Icons.broken_image, size: 40)),
      ),
    )
        : Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            ext == 'pdf' ? Icons.picture_as_pdf : Icons.description,
            size: 40,
            color: ext == 'pdf' ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );

    if (onRemove == null) return content;

    return Stack(
      children: [
        content,
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}