import 'package:flutter/material.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/chat_bubble.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/message_box.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ChatBubble(
                  avatarUrl:
                      'https://t3.ftcdn.net/jpg/05/76/94/70/360_F_576947051_DFT5rJEsF8yturr1DOlB3rxhtxswGSmP.jpg',
                  message:
                      'Hello, World! Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!',
                  isMe: true,
                ),
                ChatBubble(
                  avatarUrl:
                      'https://t3.ftcdn.net/jpg/05/76/94/70/360_F_576947051_DFT5rJEsF8yturr1DOlB3rxhtxswGSmP.jpg',
                  message:
                      'Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!',
                  isMe: false,
                ),
                MessageBox(
                  onSend: (String value) {
                    print('Message sent $value');
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
