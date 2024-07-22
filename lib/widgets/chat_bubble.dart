import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? avatarUrl;
  final String message;
  final bool isMe;
  const ChatBubble({
    super.key,
    required this.avatarUrl,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // Add the avatar
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const _DefaultAvatarWidget(),
                  placeholder: (context, url) => const _DefaultAvatarWidget(),
                )
              : const _DefaultAvatarWidget(),
        ),
      ),
    );

    // Add the bubble
    widgets.add(
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.black26 : Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe ? widgets.reversed.toList() : widgets,
      ),
    );
  }
}

class _DefaultAvatarWidget extends StatelessWidget {
  const _DefaultAvatarWidget();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.person_rounded,
      size: 12,
      color: Colors.black,
    );
  }
}
