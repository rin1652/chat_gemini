import 'package:google_generative_ai/google_generative_ai.dart';

class GenAIModel {
  late final GenerativeModel _model;

  GenAIModel() {
    const apiKey = String.fromEnvironment('apiKey');

    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }

  Future<GenerateContentResponse?> sendMessage(List<Content> contents) =>
      _model.generateContent(contents);
}
