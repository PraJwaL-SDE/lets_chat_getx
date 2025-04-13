import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:lest_chat_5/app/data/models/message_model.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';

class ChatListTileController extends GetxController {


  var downloading = false.obs;
  var downloaded = false.obs;
  var uploading = false.obs;
  var uploaded = false.obs;



  Future uploadFile(String senderId, String receiverId,String filepath) async {
    uploading.value = true;
    await MessageProvider.uploadFileMessage(senderId, receiverId, filepath);
    uploading.value = false;
    uploaded.value = true;
  }

  Future<String?> downloadFile(String url) async {
    downloading.value = true;
    try {
      // Locate the Downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download/Lets Chat');
      if (!await downloadsDir.exists()) {
        // Create the "Lets Chat" folder if it doesn't exist
        await downloadsDir.create(recursive: true);
      }

      // Get the file name from the URL
      final fileName = path.basename(url);

      // Full path for the downloaded file
      final filePath = path.join(downloadsDir.path, fileName);

      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Save the file to the "Lets Chat" directory
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        downloaded.value = true;
        Get.snackbar('Success', 'File downloaded to $filePath');
        return filePath;
      } else {
        Get.snackbar('Error', 'Failed to download file');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      downloading.value = false;
    }
  }
}
