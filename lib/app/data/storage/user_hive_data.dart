import 'package:hive_flutter/hive_flutter.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';

class UserHiveData {
  static late Box<UserModel> _userBox;

  /// Initialize the Hive box
  static Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter()); // Register the adapter.
    }
    _userBox = await Hive.openBox<UserModel>('userBox');
  }

  /// Save a user model to the box
  static Future<void> setUserModel(UserModel userModel) async {
    try {
      await _userBox.put(userModel.id, userModel);
    } catch (e) {
      print('Error saving userModel: $e');
    }
  }

  /// Retrieve a user model from the box
  static UserModel? getUserModel(String id) {
    try {
      return _userBox.get(id);
    } catch (e) {
      print('Error retrieving userModel: $e');
      return null;
    }
  }

  /// Delete a user model from the box
  static Future<void> deleteUserModel(String id) async {
    try {
      await _userBox.delete(id);
    } catch (e) {
      print('Error deleting userModel: $e');
    }
  }

  /// Get all user models as a list
  static Future<List<UserModel>> getAllUsers() async{
    try {
      return await _userBox.values.toList();
    } catch (e) {
      print('Error retrieving all users: $e');
      return [];
    }
  }
  static Future<void> setCurrentUser(UserModel userModel) async {
    try {
      await _userBox.put('current_user', userModel);
    } catch (e) {
      print('Error setting current user: $e');
    }
  }

  /// Get the current user
  static UserModel? getCurrentUser() {
    try {
      return _userBox.get('current_user');
    } catch (e) {
      print('Error retrieving current user: $e');
      return null;
    }
  }
}
