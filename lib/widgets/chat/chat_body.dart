import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:intl/intl.dart';

String? messageText;
GlobalKey<FormState> formKey = GlobalKey<FormState>();
var user = FirebaseAuth.instance.currentUser;
final fireStore = FirebaseFirestore.instance;

class ChatBody extends StatefulWidget {
  final String imageURL;
  final String userID;
  final String chatID;
  const ChatBody(
      {super.key,
      required this.imageURL,
      required this.userID,
      required this.chatID});

  @override
  State<StatefulWidget> createState() {
    return ChatBodyState();
  }
}

class ChatBodyState extends State<ChatBody> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime;

    if (timestamp != null) {
      dateTime = timestamp.toDate();
    } else {
      // تعيين قيمة افتراضية للوقت (مثلاً تاريخ اليوم الحالي)
      dateTime = DateTime.now();
    }

    // تحديد التنسيق المطلوب للوقت
    DateFormat formatter = DateFormat('hh:mm a');

    // تحويل الوقت إلى تنسيق مقروء
    String formattedTime = formatter.format(dateTime);

    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: background2),
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection('messages')
                .orderBy('created_at')
                .snapshots(),
            builder: (context, snapshot) {
              List<ItemChat> items = [];
              if (snapshot.hasData) {}

              if (snapshot.hasData) {
                final messages = snapshot.data!.docs;
                for (var message in messages) {
                  if (message.get('chatID') == widget.chatID) {
                    items.add(ItemChat(
                        chat: message.get('sender_id') == user!.uid ? 0 : 1,
                        avatar: message.get('sender_id') == user!.uid
                            ? null
                            : widget.imageURL,
                        message: message.get('content'),
                        time: formatTimestamp(
                            message.get('created_at') ?? Timestamp.now())));
                  }
                }
              }
              return ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  reverse: true,
                  children: [
                    Column(
                      children: items,
                    ),
                  ]);
            },
          )),
    );
  }
}

class ItemChat extends StatefulWidget {
  final String message, time;
  String? avatar;
  final int chat;
  ItemChat(
      {super.key,
      required this.chat,
      this.avatar,
      required this.message,
      required this.time});
  @override
  State<StatefulWidget> createState() {
    return ItemChatState();
  }
}

class ItemChatState extends State<ItemChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.chat == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.chat == 1
            ? Text(
                widget.time,
                style: const TextStyle(color: Color(0xFF106865)),
              )
            : const SizedBox(),
        Flexible(
          child: Container(
            margin:
                const EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.chat == 0
                  ? const Color(0xFFE3EEED)
                  : const Color(0xFFB8D4D3),
              borderRadius: widget.chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Text(widget.message),
          ),
        ),
        widget.avatar != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.avatar!),
                // size: 55,
              )
            : Text(
                widget.time,
                style: const TextStyle(color: Colors.black),
              ),
      ],
    );
  }
}

class MessageEntryBox extends StatefulWidget {
  final String userID;
  final String userName;
  final String avatar;
  const MessageEntryBox(
      {super.key,
      required this.userID,
      required this.userName,
      required this.avatar});

  @override
  State<StatefulWidget> createState() {
    return MessageEntryBoxState();
  }
}

class MessageEntryBoxState extends State<MessageEntryBox> {
  final controller = TextEditingController();
  late String userPicture, name;
  int chatsLength = 0;

  getChatsLength() async {
    print('chats step 11111111111111111111111111');
    var chats = await fireStore.collection('chats').get();
    for (var user in chats.docs) {
      setState(() {
        chatsLength++;
      });
    }
    print('chats step 222222222222222222222222');
    print('+++++++++++++ >>>>>>>>>>>> $chatsLength');
  }

  getUserData() async {
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      userPicture = userData.data()!['avatar'];
      name = userData.data()!['fullname'];
    });
  }

  @override
  void initState() {
    getChatsLength();
    getUserData();
    super.initState();
  }

  sendMessage() async {
    if (messageText == null || messageText!.trim().isEmpty) return;

    controller.clear();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String chatID1 = '${user!.uid}%%${widget.userID}';
    String chatID2 = '${widget.userID}%%${user!.uid}';
    String? finalChatID;

    try {
      // Check if chat already exists between these two users
      var chatQuery = await _firestore
          .collection('chats')
          .where(FieldPath.documentId, whereIn: [chatID1, chatID2]).get();

      if (chatQuery.docs.isNotEmpty) {
        // Existing chat found
        finalChatID = chatQuery.docs.first.id;
      } else {
        // Create a new chat
        finalChatID = chatID1;

        await _firestore.collection('chats').doc(finalChatID).set({
          'user1_id': user!.uid,
          'user2_id': widget.userID,
          'user1_username': name,
          'user2_username': widget.userName,
          'user1_avatar': userPicture,
          'user2_avatar': widget.avatar,
          'last_message': messageText,
          'last_message_time': FieldValue.serverTimestamp(),
        });
      }

      // Add message to the chat
      await _firestore.collection('messages').add({
        'chatID': finalChatID,
        'sender_id': user!.uid,
        'recipient_id': widget.userID,
        'content': messageText,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Update last message in chat
      await _firestore.collection('chats').doc(finalChatID).update({
        'last_message': messageText,
        'last_message_time': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          color: background2,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                messageText = val;
              },
              decoration: InputDecoration(
                hintText: ' أكتب رسالتك هنا...',
                suffixIcon: Container(
                  margin: const EdgeInsets.only(left: 2),
                  padding: const EdgeInsets.fromLTRB(5, 14, 18, 14),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, size: 30),
                    color: const Color(0xFF12706D),
                    onPressed: () {
                      messageText!.trim().isEmpty ? null : sendMessage();
                    },
                  ),
                ),
                filled: true,
                fillColor: Colors.blueGrey[50],
                labelStyle: const TextStyle(fontSize: 12),
                contentPadding: const EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF12706D)),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF12706D)),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
