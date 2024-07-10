import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final ValueChanged<String> onSend;

  const MessageBox({super.key, required this.onSend});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controllerMessage = TextEditingController();
  @override
  void dispose() {
    _controllerMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controllerMessage,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: 'Type a message...',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              color: Colors.black38,
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSend(_controllerMessage.text);
              _controllerMessage.clear();
            },
            icon: const Icon(Icons.send),
          ),
        ),
        onSubmitted: (value) {
          widget.onSend(value);
          _controllerMessage.clear();
        },
      ),
    );
  }
}
