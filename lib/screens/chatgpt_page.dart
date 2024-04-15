import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/utils/static.dart';

class ChatGPTPage extends ConsumerStatefulWidget {
  num trigger;
  ChatGPTPage({Key? key, required this.trigger});

  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends ConsumerState<ChatGPTPage> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeChatGPT();
  }

  Future<void> initializeChatGPT() async {
    print("ChatGPT initialized");
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  Future<String> getResponse(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    await Future.delayed(Duration(seconds: 2));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $chatGPT',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'model': 'gpt-3.5-turbo',
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    if (userMessage.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true; // Set loading state to true
        });

        String chatGPTResponse = await getResponse(userMessage);

        setState(() {
          _chatMessages
              .add(ChatMessage(user: userMessage, chatGPT: chatGPTResponse));
          _isLoading = false;
        });

        _messageController.clear();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        User? user = ref.watch(userStateNotifierProvider);
    return Scaffold(
      appBar: widget.trigger == 1 ? const CustomAppBarBckBtn() : null,
      body: Column(
        children: [
          Expanded(
            child: _chatMessages.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'lib/assets/lottie/chatgptpage.json',
                          width: 400,
                          height: 400,
                        ),
                        Text(
                          "Ask Me Anything...",
                          style: myTextStylefontsize16,
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ListTile(
                                tileColor: bgColor,
                                textColor: Colors.white,
                                title: GestureDetector(
                                  onLongPress: () {
                                    _copyToClipboard(_chatMessages[index].user);
                                  },
                                  child: Text(
                                    '${user!.displayName}: ${_chatMessages[index].user}',
                                    style: myTextStylefontsize14White,
                                  ),
                                ),
                                subtitle: GestureDetector(
                                  onLongPress: () {
                                    _copyToClipboard(
                                        _chatMessages[index].chatGPT);
                                  },
                                  child: Text(
                                    'ChatGPT: ${_chatMessages[index].chatGPT}',
                                    style: myTextStylefontsize14White,
                                  ),
                                ),
                              )));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: bgColor,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask a question...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Material(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    onTap: _isLoading ? null : _sendMessage,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
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

class ChatMessage {
  final String user;
  final String chatGPT;

  ChatMessage({required this.user, required this.chatGPT});
}
