import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vidyamani/utils/static.dart';

class ChatGPTPage extends StatefulWidget {
  const ChatGPTPage({Key? key}) : super(key: key);

  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  TextEditingController _messageController = TextEditingController();

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
        'Authorization': 'Bearer $ChatGPT',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'model': 'gpt-3.5-turbo',
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('API Error: ${response.statusCode}');
      print('Error Body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    if (userMessage.isNotEmpty) {
      try {
        String chatGPTResponse = await getResponse(userMessage);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User: $userMessage'),
                SizedBox(height: 10),
                Text('ChatGPT: $chatGPTResponse'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Clear the message input
        _messageController.clear();
      } catch (e) {
        // Handle exceptions here
        print('Error: $e');
        // Optionally show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ChatGPT'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask a question...',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ),
        ],
      ),
    );
  }
}
