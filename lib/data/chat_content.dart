import 'package:equatable/equatable.dart';

enum Sender { user, gemini }

// extends Equatable vì genAIState đòi props type List<Object?>
// nên phải có props để sử dụng
// List<Object?> get props => Lits<content>;

class ChatContent extends Equatable {
  final String message;
  final Sender sender;

  const ChatContent.user(this.message) : sender = Sender.user;
  const ChatContent.gemini(this.message) : sender = Sender.gemini;

  @override
  List<Object?> get props => [sender, message];
}
