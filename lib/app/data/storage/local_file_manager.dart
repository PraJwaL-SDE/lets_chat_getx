import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LocalFileManager {
  static ImagePicker imagePicker = ImagePicker();
  static Future<File?> getImageFromLocal(String fileName) async {
    String path = "Lets Chat/images/"; // Sub-directory path
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    // Combine the directory and the file path
    String fullPath = "${generalDownloadDir.path}/$path$fileName";

    // Check if the file exists
    File file = File(fullPath);
    if (await file.exists()) {
      return file;
    } else {
      print("File not found at: $fullPath");
      return null; // Return null if the file doesn't exist
    }
  }


  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      print("No image selected.");
      return null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      print("No image captured.");
      return null;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }
  static Future<File?> pickVideoFromGallery() async {
    try {
      final XFile? pickedFile = await imagePicker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      print("No video selected.");
      return null;
    } catch (e) {
      print("Error picking video: $e");
      return null;
    }
  }
}
