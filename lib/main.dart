import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat_with_gemini_in_flutter/bloc/gen_ai_bloc.dart';
import 'package:public_chat_with_gemini_in_flutter/data/chat_content.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/chat_bubble.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/message_box.dart';

const imageGemini =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s';
const imageUser = 'assets/images/logo_carrot.jpg';
void main() {
  runApp(
    BlocProvider<GenAiBloc>(
      create: (context) => GenAiBloc(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  void scrollEndList() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
                child: BlocBuilder<GenAiBloc, GenAiState>(
                  builder: (context, state) {
                    final List<ChatContent> data = [];

                    if (state is MessageUpdate) {
                      data.addAll(state.contents);
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => scrollEndList(),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
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
                  context.read<GenAiBloc>().add(SendMessageEvent(value));
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
