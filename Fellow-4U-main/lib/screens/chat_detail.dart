import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../core/message.dart';
import 'add_friend.dart';
import 'guide_detail.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen({super.key, required this.name, required this.avatar});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Message> _messages;
  late String _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = widget.name.replaceAll(' ', '_').toLowerCase();
    
    // Initialize with default messages if chat is new
    ChatStorage.initializeChat(_chatId, [
      Message(
        text: 'hi, this is ${widget.name}',
        isMe: false,
        timestamp: DateTime(2020, 1, 28, 10, 30),
        avatarUrl: widget.avatar,
      ),
      Message(
        text: 'It is a long established fact that a reader will be distracted by the',
        isMe: false,
        timestamp: DateTime(2020, 1, 28, 10, 30),
        avatarUrl: widget.avatar,
      ),
      Message(
        text: "as opposed to using 'Content here",
        isMe: true,
        timestamp: DateTime(2020, 1, 28, 10, 31),
      ),
      Message(
        text: "There are many variations of passages",
        isMe: true,
        timestamp: DateTime(2020, 1, 28, 10, 31),
      ),
    ]);
    
    _messages = ChatStorage.getMessages(_chatId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      text: _messageController.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      ChatStorage.addMessage(_chatId, newMessage);
      _messages = ChatStorage.getMessages(_chatId);
    });

    _messageController.clear();
    
    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailScreen(
                  name: widget.name,
                  location: 'Danang, Vietnam',
                  avatar: widget.avatar,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.avatar)),
              const SizedBox(width: 10),
              Text(
                widget.name,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: primaryColor,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFriendScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + 1, // +1 for date header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          _messages.isNotEmpty
                              ? DateFormat('MMM dd, yyyy').format(_messages.first.timestamp)
                              : 'Today',
                          style: const TextStyle(color: hintColor, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                
                final message = _messages[index - 1];
                final showAvatar = index == 1 || 
                    (index > 1 && _messages[index - 2].isMe != message.isMe);
                final showTime = showAvatar && !message.isMe;
                
                return message.isMe
                    ? _buildOutgoingMessage(message)
                    : _buildIncomingMessage(
                        message.text,
                        showTime ? DateFormat('hh:mm a').format(message.timestamp) : '',
                        widget.avatar,
                        hideAvatar: !showAvatar,
                      );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildIncomingMessage(
    String text,
    String time,
    String avatarUrl, {
    bool hideAvatar = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hideAvatar
              ? const SizedBox(width: 30)
              : CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hideAvatar && time.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '${widget.name}  $time',
                      style: const TextStyle(fontSize: 11, color: hintColor),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildOutgoingMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 50),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.mic_none, color: hintColor, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice message functionality coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.image_outlined, color: hintColor, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image sharing functionality coming soon!')),
                );
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type message',
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
