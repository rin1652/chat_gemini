import 'package:flutter/material.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/chat_bubble.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/message_box.dart';
import 'package:public_chat_with_gemini_in_flutter/worker/gen_a_i_worker.dart';

const imageGemini =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s';
const imageUser = 'assets/images/logo_carrot.jpg';
void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  final GenAIWorker _genAIWorker;

  MainApp({super.key, GenAIWorker? worker})
      : _genAIWorker = worker ?? GenAIWorker();

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late GenAIWorker genAIWorker;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    genAIWorker = widget._genAIWorker;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder<List<ChatContent>>(
                  stream: genAIWorker.stream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? [];
                    // if data change then scroll to end
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollEndList();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final ChatContent chatContent = data[index];
                        final String message = chatContent.message;
                        final bool isMe = chatContent.sender == Sender.user;
                        final String avatar = isMe
                            ? imageUser
                            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s';
                        return ChatBubble(
                          avatarUrl: avatar,
                          message: message,
                          isMe: isMe,
                        );
                      },
                    );
                  },
                ),
              ),
              MessageBox(
                onSend: (String value) {
                  genAIWorker.sendToGemini(value);
                  _scrollEndList();
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  void _scrollEndList() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
