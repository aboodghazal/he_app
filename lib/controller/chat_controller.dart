import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserID => _auth.currentUser?.uid ?? '';

  /// Generate unique chat ID (alphabetical order of user IDs)
  String getChatID(String otherUserID) {
    final ids = [currentUserID, otherUserID]..sort();
    return ids.join('%%'); // use %% to match your existing chatID format
  }

  /// Send a message and create chat metadata if missing
  Future<void> sendMessage({
    required String receiverID,
    required String receiverName,
    required String receiverAvatar,
    required String senderName,
    required String senderAvatar,
    required String messageText,
  }) async {
    if (messageText.trim().isEmpty) return;

    try {
      final chatID = getChatID(receiverID);
      final timestamp = FieldValue.serverTimestamp();

      // Message structure
      final message = {
        'senderID': currentUserID,
        'receiverID': receiverID,
        'message': messageText.trim(),
        'timestamp': timestamp,
      };

      // Store message
      await _firestore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add(message);

      // Update or create chat document
      await _firestore.collection('chats').doc(chatID).set({
        'user1_id': currentUserID,
        'user2_id': receiverID,
        'user1_username': senderName,
        'user2_username': receiverName,
        'user1_avatar': senderAvatar,
        'user2_avatar': receiverAvatar,
        'last_message': messageText,
        'last_message_time': timestamp,
      }, SetOptions(merge: true));
    } catch (e) {
      print('🔥 Error sending message: $e');
    }
  }

  /// Real-time message stream
  Stream<QuerySnapshot> messagesStream(String receiverID) {
    final chatID = getChatID(receiverID);
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
