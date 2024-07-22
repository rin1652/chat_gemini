import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/message_box.dart';

import '../material_wrapper_extension.dart';

void main() {
  _verifyUIComponents();
  _givenMessageBoxIsLoaded();
}

void _givenMessageBoxIsLoaded() {
  testWidgets(
      'given MessageBox is loaded'
      ' when tap on IconButton and enter action Done in TextField'
      ' then onSendMessage is triggered', (widgetTester) async {
    // given
    String result = '';
    final Widget widget = MessageBox(onSend: (value) {
      result = value;
    });

    // when
    await widgetTester.wrapAndPump(widget);

    // when tap Icon
    await widgetTester.enterText(
        find.byType(TextField), 'This is a simple message submit with icon');
    await widgetTester.tap(find.byType(Icon));
    // then
    expect(result, 'This is a simple message submit with icon');

    // when enter action Done
    await widgetTester.enterText(find.byType(TextField),
        'This is a simple message submit with action done');
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    // then
    expect(result, 'This is a simple message submit with action done');
  });
}

void _verifyUIComponents() {
  testWidgets('Verify UI Components', (widgetTester) async {
    // given
    MessageBox widget = MessageBox(onSend: (String string) {});

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    // padding
    expect(
        find.descendant(
          of: find.byType(MessageBox),
          matching: find.ancestor(
            of: find.byType(Padding),
            matching: find.byType(TextField),
          ),
        ),
        findsOneWidget);
    // TexField
    expect(
      find.descendant(
        of: find.byType(MessageBox),
        matching: find.descendant(
          of: find.byType(Padding),
          matching: find.byType(TextField),
        ),
      ),
      findsOneWidget,
    );

    // IconButton
    expect(
      find.descendant(
        of: find.descendant(
          of: find.byType(MessageBox),
          matching: find.descendant(
            of: find.byType(Padding),
            matching: find.byType(TextField),
          ),
        ),
        matching: find.byType(IconButton),
      ),
      findsOneWidget,
    );
  });
}
