import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/chat_bubble.dart';

import '../material_wrapper_extension.dart';

void main() {
  _testVerifyUIComponent();
  _testVerifyUIComponentIsMe();
  _testVerifyUIComponentNotMe();
  _testAvatarUrlNull();
  _testAvatarUrlNotNull();
}

void _testVerifyUIComponentIsMe() {
  return testWidgets(
    'given chatBubble with isMine == true,'
    ' when load ChatBubble,'
    ' then Container deco color is black26, and row alignment is end'
    ' and widget is reversed',
    (widgetTester) async {
      // given
      const widget = ChatBubble(
        avatarUrl: 'avatarUrl',
        message: 'message',
        isMe: true,
      );

      //when
      await widgetTester.wrapAndPump(widget);

      // then
      // Container color
      final BoxDecoration decoration = (widgetTester.widget(
        find.byType(Container),
      ) as Container)
          .decoration as BoxDecoration;
      expect(decoration.color, Colors.black26);

      // row alignment
      final Row row = widgetTester.widget(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
      expect(row.children.length, 2);
      // có phải khung chat không?
      expect(row.children.first, isA<Container>());

      // có phải avatar không?
      expect(row.children.last, isA<Padding>());
    },
  );
}

void _testVerifyUIComponentNotMe() {
  return testWidgets(
    'given chatBubble with isMine == false,'
    ' when load ChatBubble,'
    ' then Container deco color is black54, and row alignment is start'
    ' and widget is not reversed',
    (widgetTester) async {
      // given
      const widget = ChatBubble(
        avatarUrl: 'avatarUrl',
        message: 'message',
        isMe: false,
      );

      //when
      await widgetTester.wrapAndPump(widget);

      // then
      // Container color
      final BoxDecoration decoration = (widgetTester.widget(
        find.byType(Container),
      ) as Container)
          .decoration as BoxDecoration;
      expect(decoration.color, Colors.black54);

      // row alignment
      final Row row = widgetTester.widget(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.start);
      expect(row.children.length, 2);
      // có phải khung chat không?
      expect(row.children.last, isA<Container>());

      // có phải avatar không?
      expect(row.children.first, isA<Padding>());
    },
  );
}

void _testVerifyUIComponent() {
  return testWidgets('verify UI component', (widgetTester) async {
    //given
    const Widget widget = ChatBubble(
      avatarUrl: 'avatarUrl',
      message: 'message',
      isMe: true,
    );

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    // tìm 1 padding và thấy 1 cái ClipRRect ở trong đó (findsOneWidget) thì pass
    expect(
      find.descendant(
        of: find.byType(Padding),
        matching: find.byType(ClipRRect),
      ),
      findsOneWidget,
    );

    // then container
    // Container -> Padding -> Text
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Text),
        ),
      ),
      findsOneWidget,
    );

    // verify ClipRRect xem các thuộc tính có đúng không
    _verifyClipRRect(widgetTester);

    // verify Padding of ClipRRect
    //-> phải dùng ancestor để tìm cái ClipRRect đã rồi mới lấy thằng Padding đó
    _verifyPaddingOfClipRRect(widgetTester);

    // verify text
    _verifyText(widgetTester);

    // verify Container
    _verifyContainer(widgetTester);
  });
}

void _verifyContainer(WidgetTester widgetTester) {
  /// container
  final Container container = widgetTester.widget(
    find.byType(Container),
  );
  expect(container.decoration, isNotNull);
  expect(container.decoration, isA<BoxDecoration>());

  final BoxDecoration decoration = container.decoration as BoxDecoration;
  expect(decoration.borderRadius, BorderRadius.circular(16.0));

  // // padding
  // final Padding padding = widgetTester.widget(
  //   find.descendant(
  //     of: find.byType(Row),
  //     matching: find.ancestor(
  //       of: find.byType(Text),
  //       matching: find.byType(
  //         Padding,
  //       ),
  //     ),
  //   ),
  // );
  // expect(padding.padding, const EdgeInsets.all(8.0));
}

void _verifyText(WidgetTester widgetTester) {
  final Text text = widgetTester.widget(
    find.descendant(
      of: find.byType(Container),
      matching: find.descendant(
        of: find.byType(Padding),
        matching: find.byType(Text),
      ),
    ),
  );

  expect(text.data, 'message');
}

void _verifyClipRRect(WidgetTester widgetTester) {
  final ClipRRect rRect = widgetTester.widget(
    find.descendant(
      of: find.byType(Row),
      matching: find.descendant(
        of: find.byType(Padding),
        matching: find.byType(ClipRRect),
      ),
    ),
  );
  expect(rRect.borderRadius, BorderRadius.circular(16));
}

void _verifyPaddingOfClipRRect(WidgetTester widgetTester) {
  final Padding paddingOfRRect = widgetTester.widget(
    find.descendant(
      of: find.byType(Row),
      matching: find.ancestor(
        of: find.byType(
          ClipRRect,
        ),
        matching: find.byType(Padding),
      ),
    ),
  );
  expect(
    paddingOfRRect.padding,
    const EdgeInsets.all(8.0),
  );
}

void _testAvatarUrlNull() {
  return testWidgets(
    'given photoUrl is null,'
    ' when load ChatBubble,'
    ' then CachedNetworkImage is not present, and Icon with data Icons.person is present',
    (widgetTester) async {
      //given
      const Widget widget =
          ChatBubble(avatarUrl: null, message: 'message', isMe: true);

      // when
      await widgetTester.wrapAndPump(widget);

      // then
      expect(find.byType(CachedNetworkImage), findsNothing);
      // không chắc là có đúng Icons.person không nên phải dùng Predecate
      // nó sẽ đưa 1 widget thì ta sẽ kiểm tra xem nó có đúng là cái widget mình muốn hay không?
      expect(
        find.byWidgetPredicate(
          (widget) {
            if (widget is! Icon) {
              return false;
            }

            return widget.icon == Icons.person_rounded;
          },
        ),
        findsOneWidget,
      );
    },
  );
}

void _testAvatarUrlNotNull() {
  testWidgets(
      'given AvatarUrl is not null'
      ' when load ChatBubble'
      ' then CachedNetworkImage is present', (widgetTester) async {
    // given
    const Widget widget = ChatBubble(
      avatarUrl: 'avatarUrl',
      message: 'message',
      isMe: true,
    );

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    expect(find.byType(CachedNetworkImage), findsOne);
  });
}
