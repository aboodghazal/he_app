// import 'package:flutter/material.dart';
// import 'package:health_app/controller/chat_controller.dart';
// import '../../widgets/chat/chat_body.dart';
// import '../../widgets/chat/chat_header.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return ChatScreenState();
//   }
// }

// class ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     print('chat screen');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final routeArgument =
//         ModalRoute.of(context)?.settings.arguments as Map<String, String>;
//     final name = routeArgument['name'];
//     final avatar = routeArgument['avatar'];
//     final userID = routeArgument['userID'];
//     final chatID = routeArgument['chatID'];

//     print('-------------> $userID');

//     return Scaffold(
//       backgroundColor: const Color(0xFF12706D),
//       body: Container(
//         padding: const EdgeInsets.only(top: 50),
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 ChatHeader(name: name!),
//                 Expanded(
//                   child: ChatBody(
//                     imageURL: avatar!,
//                     userID: userID!,
//                     chatID: chatID!,
//                     // repository: ChatRepository(),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 120,
//                 ),
//               ],
//             ),
//             MessageEntryBox(
//               userID: userID,
//               userName: name,
//               avatar: avatar,
//               // repository: ChatRepository(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/controller/chat_controller.dart';
import 'package:health_app/widgets/chat/chat_body.dart';
import 'package:health_app/widgets/chat/chat_header.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = ChatController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? currentUserName;
  String? currentUserAvatar;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserInfo();
  }

  /// Load current user data from Firestore (assumes you have 'users' collection)
  Future<void> _fetchCurrentUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        currentUserName = doc['fullname'] ?? 'Me';
        currentUserAvatar = doc['avatar'] ??
            'https://cdn-icons-png.flaticon.com/512/149/149071.png';
      });
    } else {
      setState(() {
        currentUserName = 'Me';
        currentUserAvatar =
            'https://cdn-icons-png.flaticon.com/512/149/149071.png';
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({
    required String receiverID,
    required String receiverName,
    required String receiverAvatar,
  }) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (currentUserName == null || currentUserAvatar == null) {
      await _fetchCurrentUserInfo(); // ensure we have sender info
    }
    _messageController.clear();

    await chatController.sendMessage(
      receiverID: receiverID,
      receiverName: receiverName,
      receiverAvatar: receiverAvatar,
      senderName: currentUserName ?? 'Me',
      senderAvatar: currentUserAvatar ??
          'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      messageText: text,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    final name = routeArgs['name'] ?? 'User';
    final avatar = routeArgs['avatar'] ??
        'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    final userID = routeArgs['userID'] ?? '';

    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF12706D),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ChatHeader(name: name),

              /// --- Messages Stream ---
              Expanded(
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: chatController.messagesStream(userID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "Start the conversation!",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        final messages = snapshot.data!.docs;

                        return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            bottom: 90,
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final data = message.data() as Map<String, dynamic>;

                            final isMe = data['senderID'] == currentUserID;
                            return ItemChat(
                              chat: isMe ? 0 : 1,
                              avatar: isMe ? null : avatar,
                              message: data['message'] ?? '',
                              time: formatTimestamp(
                                data['created_at'] ?? Timestamp.now(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// --- Message Input ---
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    // color: background2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            filled: true,
                            suffixIcon: Container(
                              margin: const EdgeInsets.only(left: 2),
                              padding: const EdgeInsets.fromLTRB(5, 14, 18, 14),
                              child: IconButton(
                                icon: const Icon(Icons.send_rounded, size: 30),
                                color: const Color(0xFF12706D),
                                onPressed: () => _sendMessage(
                                  receiverID: userID,
                                  receiverName: name,
                                  receiverAvatar: avatar,
                                ),
                              ),
                            ),
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.all(20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF12706D)),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF12706D)),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
