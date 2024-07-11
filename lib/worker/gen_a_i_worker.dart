import 'dart:async';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';

class GenAIWorker {
  late final GenerativeModel _model;

  final List<ChatContent> _contents = [];

  final StreamController<List<ChatContent>> _streamController =
      StreamController.broadcast();

  get contents => _contents;

  Stream<List<ChatContent>> get stream => _streamController.stream;

  GenAIWorker() {
    final apiKey = const String.fromEnvironment('apiKey');
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }

  void sendToGemini(String value) async {
    _contents.add(ChatContent.user(value));
    _streamController.sink.add(contents);
    try {
      final GenerateContentResponse response =
          await _model.generateContent([Content.text(value)]);
      _contents
          .add(ChatContent.gemini(response.text ?? 'Gemini not response...'));
      _streamController.sink.add(contents);
    } catch (e) {
      log(e.toString());
      _contents.add(ChatContent.gemini('Gemini error...'));
      _streamController.sink.add(contents);
    }
  }
}

enum Sender { user, gemini }

class ChatContent {
  final String message;
  final Sender sender;

  ChatContent.user(this.message) : sender = Sender.user;
  ChatContent.gemini(this.message) : sender = Sender.gemini;
}
