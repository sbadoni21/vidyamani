import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/utils/static.dart';

class ChatGPTPage extends ConsumerStatefulWidget {
  const ChatGPTPage({Key? key}) : super(key: key);

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
          _isLoading = false; // Set loading state to false
        });

        _messageController.clear();
      } catch (e) {
        setState(() {
          _isLoading = false; // Set loading state to false in case of an error
        });
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider);
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                      title: Text(
                          '${user!.displayName}: ${_chatMessages[index].user}'),
                      subtitle:
                          Text('ChatGPT: ${_chatMessages[index].chatGPT}'),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask a question...',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: bgColor,
                          )
                        : const Text('Send'),
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
