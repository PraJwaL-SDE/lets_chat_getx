import 'package:hive_flutter/hive_flutter.dart';

class LocalImageHive {
  static const String _boxName = 'localImagePaths';

  /// Initialize Hive and open the box for storing image paths.
  static Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  /// Save the image path associated with a specific message ID.
  static Future<void> setImagePath(String messageId, String imagePath) async {
    final box = Hive.box<String>(_boxName);
    await box.put(messageId, imagePath);
  }

  /// Retrieve the image path for a given message ID.
  static String? getImagePath(String messageId) {
    final box = Hive.box<String>(_boxName);
    return box.get(messageId);
  }
}
