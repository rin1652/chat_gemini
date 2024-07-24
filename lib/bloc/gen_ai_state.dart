part of 'gen_ai_bloc.dart';

sealed class GenAiState extends Equatable {
  const GenAiState();
}

final class GenAiInitial extends GenAiState {
  @override
  List<Object> get props => [];
}

class MessageUpdate extends GenAiState {
  final List<ChatContent> contents;

  const MessageUpdate(this.contents);

  @override
  List<Object?> get props => [
        ...contents,
      ];
}
