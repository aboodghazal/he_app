import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/utils/app_route.dart';
import 'package:intl/intl.dart';
import 'avatar.dart';

class ContactsBody extends StatefulWidget {
  const ContactsBody({super.key});

  @override
  State<StatefulWidget> createState() => ContactsBodyState();
}

class ContactsBodyState extends State<ContactsBody> {
  final user = FirebaseAuth.instance.currentUser;

  /// Format timestamp into readable time (e.g. 08:45 PM)
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: background2,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .orderBy('last_message_time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No conversations yet",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            final chats = snapshot.data!.docs;
            final List<ItemChats> items = [];

            for (var chat in chats) {
              final chatData = chat.data() as Map<String, dynamic>;

              // Skip if current user is not part of this chat
              if (chatData['user1_id'] != user!.uid &&
                  chatData['user2_id'] != user!.uid) continue;

              // Determine who is the other user
              final bool isUser1 = chatData['user1_id'] == user!.uid;
              final otherUserID =
                  isUser1 ? chatData['user2_id'] : chatData['user1_id'];
              final otherUserName = isUser1
                  ? chatData['user2_username']
                  : chatData['user1_username'];
              final otherUserAvatar =
                  isUser1 ? chatData['user2_avatar'] : chatData['user1_avatar'];

              items.add(
                ItemChats(
                  avatar: otherUserAvatar ?? '',
                  name: otherUserName ?? 'User',
                  chat: chatData['last_message'] ?? '',
                  time: formatTimestamp(chatData['last_message_time']),
                  userID: otherUserID,
                  chatID: chat.id,
                ),
              );
            }

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "No active chats yet",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: items,
            );
          },
        ),
      ),
    );
  }
}

class ItemChats extends StatelessWidget {
  final String avatar, name, chat, time, userID, chatID;

  const ItemChats({
    super.key,
    required this.avatar,
    required this.name,
    required this.chat,
    required this.time,
    required this.userID,
    required this.chatID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.chatScreen, arguments: {
          'name': name,
          'avatar': avatar,
          'userID': userID,
          'chatID': chatID,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: background2,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Avatar(
              margin: const EdgeInsets.only(left: 20, right: 15),
              size: 55,
              image: avatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
