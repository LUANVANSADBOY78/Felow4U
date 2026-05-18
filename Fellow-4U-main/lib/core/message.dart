class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? avatarUrl;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isMe': isMe,
      'timestamp': timestamp.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isMe: json['isMe'],
      timestamp: DateTime.parse(json['timestamp']),
      avatarUrl: json['avatarUrl'],
    );
  }
}

// Simple in-memory chat storage
class ChatStorage {
  static final Map<String, List<Message>> _chats = {};

  static List<Message> getMessages(String chatId) {
    return _chats[chatId] ?? [];
  }

  static void addMessage(String chatId, Message message) {
    if (_chats[chatId] == null) {
      _chats[chatId] = [];
    }
    _chats[chatId]!.add(message);
  }

  static void initializeChat(String chatId, List<Message> initialMessages) {
    if (_chats[chatId] == null || _chats[chatId]!.isEmpty) {
      _chats[chatId] = initialMessages;
    }
  }
}
