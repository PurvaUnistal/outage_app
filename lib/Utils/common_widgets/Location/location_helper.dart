import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:outage_app/Utils/common_widgets/gps_alert_pop_widget.dart';
import 'package:outage_app/Utils/common_widgets/gps_setting_permission_pop_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_model.dart';

enum _LocAction { cancel, retry, settings }

class LocationHelper {
  static Position? position;
  static String currentAddress = '';

  // ===========================================================================
  // FORCE LOCATION — GPS on + permission allow hone tak dialog dikhao
  // ===========================================================================

  /// true = location ready, false = user ne Cancel kiya.
  static Future<bool> ensureLocationReady(BuildContext context) async {
    while (true) {
      // 1. GPS on hai?
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!context.mounted) return false;
        final action = await _showLocationDialog(
          context,
          title: "Turn on GPS",
          message: "GPS is off. Please turn on location to add "
              "Latitude, Longitude and Address on the photo.",
          settingsLabel: "Open GPS Settings",
        );
        if (action == _LocAction.cancel) return false;
        if (action == _LocAction.settings) {
          await Geolocator.openLocationSettings();
        }
        continue;
      }

      // 2. Permission hai?
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      }

      // 3. Deny kiya -> force karo
      if (!context.mounted) return false;
      final blocked = permission == LocationPermission.deniedForever;
      final action = await _showLocationDialog(
        context,
        title: "Location permission required",
        message: blocked
            ? "Location permission is blocked. Open App Settings > Permissions > "
            "Location and select \"Allow only while using the app\"."
            : "This app needs your location to stamp the photo. "
            "Please allow location permission.",
        settingsLabel: blocked ? "Open App Settings" : null,
      );
      if (action == _LocAction.cancel) return false;
      if (action == _LocAction.settings) {
        await Geolocator.openAppSettings();
      }
      // Retry / Allow par loop dobara permission maangega
    }
  }

  static Future<_LocAction> _showLocationDialog(
      BuildContext context, {
        required String title,
        required String message,
        String? settingsLabel,
      }) async {
    final result = await showDialog<_LocAction>(
      context: context,
      barrierDismissible: false, // bahar tap karke band nahi hoga
      builder: (ctx) => PopScope(
        canPop: false, // back button se band nahi hoga
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, _LocAction.cancel),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, _LocAction.retry),
              child: Text(settingsLabel == null ? "Allow" : "Retry"),
            ),
            if (settingsLabel != null)
              TextButton(
                onPressed: () => Navigator.pop(ctx, _LocAction.settings),
                child: Text(settingsLabel),
              ),
          ],
        ),
      ),
    );
    return result ?? _LocAction.cancel;
  }

  // ===========================================================================
  // GPS CHECK (purana — baaki screens ke liye waise hi)
  // ===========================================================================

  static Future<bool> checkGps({required BuildContext context}) async {
    final serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (!serviceStatus) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (BuildContext mContext) => const GPSAlertPopWidget());
      }
      if (kDebugMode) print("GPS Service is not enabled, turn on GPS location");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (kDebugMode) print('Location permission denied: $permission');
      if (permission == LocationPermission.deniedForever && context.mounted) {
        showDialog(
            context: context,
            builder: (BuildContext c) => const GPSSettingPermissionPopWidget());
      }
      return false;
    }
    return true;
  }

  // ===========================================================================
  // GET LOCATION
  // ===========================================================================

  /// Online aur offline dono me kaam karta hai.
  /// GPS ko internet nahi chahiye. Address sirf tab milta hai jab internet ho,
  /// warna lat/long khaali address ke saath return hote hain.
  static Future<dynamic> getLocation({required BuildContext context}) async {
    if (!await checkGps(context: context)) return null;

    final position = await _getPosition();
    if (position == null) return null;
    LocationHelper.position = position;

    return _buildLocation(position, withAddress: true);
  }

  /// getLocation jaisa, lekin address lookup nahi karta (fast).
  static Future<dynamic> getLocationOfflineMode(
      {required BuildContext context}) async {
    if (!await checkGps(context: context)) return null;

    final position = await _getPosition();
    if (position == null) return null;
    LocationHelper.position = position;

    return _buildLocation(position, withAddress: false);
  }

  /// Pehle fresh GPS fix try karo, fail ho to last known position.
  static Future<Position?> _getPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (e) {
      if (kDebugMode) print("getCurrentPosition failed: $e");
    }

    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        if (kDebugMode) print("Using last known position");
        return last;
      }
    } catch (e) {
      if (kDebugMode) print("getLastKnownPosition failed: $e");
    }
    return null;
  }

  static Future<dynamic> _buildLocation(Position position,
      {required bool withAddress}) async {
    String city = "";
    String address = "";

    if (withAddress) {
      try {
        final placeMarker = await placemarkFromCoordinates(
            position.latitude, position.longitude)
            .timeout(const Duration(seconds: 5));
        if (placeMarker.isNotEmpty) {
          final place = placeMarker.first;
          city = place.locality ?? "";
          address = _formatAddress(place);
        }
      } catch (e) {
        // Internet nahi -> address skip, coordinates rakho
        if (kDebugMode) print("Address lookup skipped: $e");
      }
    }

    currentAddress = address;
    final location = <String, dynamic>{
      "lat": position.latitude,
      "long": position.longitude,
      "city": city,
      "accuracy": position.accuracy.toString(),
      "address": address,
    };
    if (kDebugMode) print(location.toString());
    return responseLocationData(location);
  }

  // ===========================================================================
  // ADDRESS
  // ===========================================================================

  static Future<String> getAddress(
      {required String lat, required String log}) async {
    try {
      final latitude = double.tryParse(lat);
      final longitude = double.tryParse(log);
      if (latitude == null || longitude == null) return "";
      final placeMarker = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 5));
      if (placeMarker.isEmpty) return "";
      return _formatAddress(placeMarker.first);
    } catch (e) {
      return "";
    }
  }

  /// Address banao — null / khaali parts skip, duplicate hata do.
  /// (Pehle "null, null, Ahmedabad" jaisa aa jaata tha)
  static String _formatAddress(Placemark place) {
    final parts = [
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.postalCode,
      place.country,
    ]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toSet()
        .toList();
    return parts.join(', ');
  }

  // ===========================================================================
  // PERMISSION (purana)
  // ===========================================================================

  static Future<bool> checkPermissions({required BuildContext context}) async {
    await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();

    bool denied = false;
    if (Platform.isAndroid) {
      final status = await Permission.locationAlways.status;
      denied = status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied;
    } else if (Platform.isIOS) {
      final permission = await Geolocator.checkPermission();
      denied = permission == LocationPermission.denied;
    }

    if (denied) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (BuildContext c) => const GPSSettingPermissionPopWidget());
      }
      return false;
    }
    return true;
  }
}