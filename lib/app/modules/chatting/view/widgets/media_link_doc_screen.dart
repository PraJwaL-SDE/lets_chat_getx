import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/chat_room.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/storage/message_hive_data.dart';


class MediaLinkDocScreen extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoom chatRoom;

  const MediaLinkDocScreen({
    super.key,
    required this.targetUser,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: "media_links",
            child: Text(
              "Media, Links & Documents",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Media"),
              Tab(text: "Links"),
              Tab(text: "Documents"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Media content will appear here.")),
            _links(),
            Center(child: Text("Documents content will appear here.")),
          ],
        ),
      ),
    );
  }

  Widget _links() {
    final linkRegex = RegExp(
      r'(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])',
      caseSensitive: false,
    );

    return FutureBuilder(
      future: MessageHiveData.getAllMessagesNow(chatRoom.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading links."));
        }
        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("No links found."));
        }

        final messages = snapshot.data as List;
        final links = messages
            .where((message) =>
        message.type == "text" &&
            linkRegex.hasMatch(message.text ?? ""))
            .map((message) => linkRegex.stringMatch(message.text!))
            .whereType<String>()
            .toList();

        if (links.isEmpty) {
          return const Center(child: Text("No links found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: links.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnyLinkPreview(
                        removeElevation: true,
                        backgroundColor: Colors.white,
                        link: links[index],
                        displayDirection: UIDirection.uiDirectionHorizontal,
                        showMultimedia: true,
                        placeholderWidget:
                        const Text("Loading preview..."),
                        errorWidget: const Text("Could not load preview."),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        links[index],
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
