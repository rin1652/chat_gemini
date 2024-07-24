part of 'gen_ai_bloc.dart';

sealed class GenAiEvent extends Equatable {
  const GenAiEvent();
}

class SendMessageEvent extends GenAiEvent {
  final String message;

  const SendMessageEvent(this.message);

  // kiểm tra event có thay đổi hay không
  @override
  List<Object?> get props => [message];
}
