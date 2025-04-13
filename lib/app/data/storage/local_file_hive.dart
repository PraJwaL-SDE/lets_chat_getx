import 'dart:io';
import 'package:hive/hive.dart';

class LocalFileHive {
  static late Box<String> _fileBox;

  /// Initialize the Hive box for storing file paths
  static Future<void> initialize() async {
    // Open or create the Hive box for storing file data
    _fileBox = await Hive.openBox<String>('local_file_hive');
    print("LocalFileHive initialized");
  }

  /// Retrieve the file path by its ID
  static String? getFileById(String id) {
    try {
      final filePath = _fileBox.get(id);
      print("Retrieved file path for ID $id: $filePath");
      return filePath;
    } catch (e) {
      print("Error retrieving file path for ID $id: $e");
      return null;
    }
  }

  /// Save the file path with the given ID
  static Future<void> setFile(String id, String filePath) async {
    try {
      // Ensure the base folder exists
      final baseFolder = Directory('/storage/emulated/0/Download/LetsChat');
      if (!await baseFolder.exists()) {
        await baseFolder.create(recursive: true);
      }

      // Save the file path in the Hive box
      await _fileBox.put(id, filePath);
      print("Saved file path for ID $id: $filePath");
    } catch (e) {
      print("Error saving file path for ID $id: $e");
    }
  }

  /// Delete a file record by its ID
  static Future<void> deleteFileById(String id) async {
    try {
      if (_fileBox.containsKey(id)) {
        await _fileBox.delete(id);
        print("Deleted file path for ID $id");
      } else {
        print("No file path found for ID $id");
      }
    } catch (e) {
      print("Error deleting file path for ID $id: $e");
    }
  }

  /// Clear all stored file paths (optional utility)
  static Future<void> clearAllFiles() async {
    try {
      await _fileBox.clear();
      print("Cleared all file paths");
    } catch (e) {
      print("Error clearing file paths: $e");
    }
  }
}
