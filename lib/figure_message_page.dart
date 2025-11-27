import 'package:flutter/material.dart';

import 'services/zhipu_ai_service.dart';
import 'tab_one_page.dart';

class FigureMessagePage extends StatefulWidget {
  const FigureMessagePage({super.key, required this.character});

  final Character character;

  @override
  State<FigureMessagePage> createState() => _FigureMessagePageState();
}

class _FigureMessagePageState extends State<FigureMessagePage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ZhipuAiService _aiService;

  final List<_ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _aiService = ZhipuAiService();
    _messages.add(
      _ChatMessage(
        role: _ChatRole.ai,
        content:
            'Hey there, I am ${widget.character.nickName}. Ready to share some travel inspiration with you!',
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(role: _ChatRole.user, content: text));
      _isSending = true;
      _textController.clear();
    });
    _scrollToBottom();

    try {
      final history = _messages
          .map(
            (m) => {
              'role': m.role == _ChatRole.user ? 'user' : 'assistant',
              'content': m.content,
            },
          )
          .toList();

      final reply = await _aiService.sendChat(
        characterName: widget.character.nickName,
        history: history,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(role: _ChatRole.ai, content: reply));
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.character.userIcon,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.character.nickName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.role == _ChatRole.user;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF933996)
                          : const Color(0xFF1E1E28),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                            Radius.circular(isUser ? 18 : 4), // speech tail
                        bottomRight:
                            Radius.circular(isUser ? 4 : 18), // speech tail
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF161622),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Say something inspiring...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          decoration: TextDecoration.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF232334),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _isSending ? null : _sendMessage,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isSending
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF555566),
                                Color(0xFF444455),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xFF933996),
                                Color(0xFFDD7BFF),
                              ],
                            ),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChatRole { user, ai }

class _ChatMessage {
  _ChatMessage({required this.role, required this.content});

  final _ChatRole role;
  final String content;
}

