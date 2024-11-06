import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GetImageWidget{
  static Future<File?> cameraCapture() async {
    await Permission.camera.request();
    try{
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 900,
        maxWidth: 1000,
      );
      if(file != null){
        File files = File(file.path);
        return files;
      } else {
        return File("");
      }
    }catch(e){
      log("cameraCapture-->${e.toString()}");
    }
    return File("");
  }

  static Future<File> galleryCapture() async {
    await Permission.storage.request();
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 900,
      maxWidth: 1000,
    );
    File files = File(file!.path);
    return files;
  }
}