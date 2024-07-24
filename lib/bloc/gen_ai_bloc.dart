import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:public_chat_with_gemini_in_flutter/data/chat_content.dart';
import 'package:public_chat_with_gemini_in_flutter/repository/gen_ai_model.dart';
import 'package:public_chat_with_gemini_in_flutter/utils/bloc_extensions.dart';

part 'gen_ai_event.dart';
part 'gen_ai_state.dart';

class GenAiBloc extends Bloc<GenAiEvent, GenAiState> {
  final List<ChatContent> _content = [];
  final GenAIModel _model = GenAIModel();

  GenAiBloc() : super(GenAiInitial()) {
    on<SendMessageEvent>(_sendMessage);
  }

  void _sendMessage(SendMessageEvent event, Emitter<GenAiState> emit) async {
    _content.add(ChatContent.user(event.message));
    emitSafely(MessageUpdate(List.from(_content)));

    try {
      final response = await _model.sendMessage([Content.text(event.message)]);
      final String? text = response?.text;

      if (text == null) {
        _content.add(const ChatContent.gemini('Unable to generate response'));
      } else {
        _content.add(ChatContent.gemini(text));
      }
    } catch (e) {
      _content.add(const ChatContent.gemini('Unable to generate response'));
    }

    emitSafely(MessageUpdate(List.from(_content)));
  }
}
