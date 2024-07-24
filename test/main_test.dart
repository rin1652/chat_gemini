import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat_with_gemini_in_flutter/data/chat_content.dart';
import 'package:public_chat_with_gemini_in_flutter/main.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/chat_bubble.dart';
import 'package:public_chat_with_gemini_in_flutter/widgets/message_box.dart';
import 'package:public_chat_with_gemini_in_flutter/worker/gen_a_i_worker.dart';

import 'material_wrapper_extension.dart';

// tạo gen AI worker
class MockGenAIWorker extends Mock implements GenAIWorker {}

void main() {
  _verifyUIComponent();
  _testGenAiWorker();
}

void _verifyUIComponent() {
  testWidgets('verify UI component', (widgetTester) async {
    // given
    Widget widget = MainApp();

    // when
    // đã có MaterialApp và Scaffold
    await widgetTester.pumpWidget(widget);

    // then
    // Center
    expect(
      find.descendant(
        of: find.byType(SafeArea),
        matching: find.ancestor(
          of: find.byType(Column),
          matching: find.byType(Center),
        ),
      ),
      findsOneWidget,
    );

    // Column
    expect(
      find.descendant(
        of: find.byType(Center),
        matching: find.byType(
          Column,
        ),
      ),
      findsOneWidget,
    );

    // check in column
    final Column column = widgetTester.widget(
      find.descendant(
        of: find.byType(Center),
        matching: find.byType(
          Column,
        ),
      ),
    );

    expect(column.children.length, 2);
    expect(column.children.first, isA<Expanded>());
    expect(column.children.last, isA<MessageBox>());

    expect(
      find.descendant(
        of: find.byType(Expanded),
        matching: find.byType(
          StreamBuilder<List<ChatContent>>,
        ),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(StreamBuilder<List<ChatContent>>),
        matching: find.byType(
          ListView,
        ),
      ),
      findsOneWidget,
    );
  });
}

void _testGenAiWorker() {
  final MockGenAIWorker worker = MockGenAIWorker();
  _testHaveData(worker);
  _testDoNotHaveData(worker);
  _testStreamDoNotReturnValue(worker);
}

void _testHaveData(MockGenAIWorker worker) {
  tearDown(() {
    reset(worker);
  });
  return testWidgets(
      'given GenAIWorker stream return List of ChatContent,'
      ' when load MainApp,'
      ' then show ListView with number of ChatBubbles matching number of ChatContents',
      (widgetTester) async {
    //given
    when(
      () => worker.stream,
    ).thenAnswer(
      (invocation) => Stream.value(
        [
          ChatContent.user('This is a message from user'),
          ChatContent.gemini('This is a message from AI'),
        ],
      ),
    );

    // tạo worker kiểu GenAIWorker để test stream
    final Widget widget = MainApp(
      worker: worker,
    );

    //when
    await widgetTester.wrapAndPump(widget);

    // khi sử dụng stream, thì frame đầu tiên sẽ load widget của mình lên
    // lúc đó stream được gọi, lúc đó sẽ có data nhưng data chưa gắn vào UI
    // nên phải gọi pumpAndSettle để update cái UI
    await widgetTester.pumpAndSettle();

    // then
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(ChatBubble),
      ),
      findsNWidgets(2),
    );

    expect(
      find.descendant(
          of: find.byType(ListView), matching: find.byType(ChatBubble)),
      findsNWidgets(2),
    );

    expect(find.text('This is a message from user'), findsOneWidget);
    expect(find.text('This is a message from AI'), findsOneWidget);
  });
}

void _testDoNotHaveData(MockGenAIWorker worker) {
  testWidgets(
      'Given GenAIWorker stream return empty list of ChatContent'
      ' when load MainApp'
      ' then show ListView 0 ChatBubbles', (widgetTester) async {
    //given
    // fake data
    when(
      () => worker.stream,
    ).thenAnswer((invocation) => Stream.value([]));
    final Widget widget = MainApp(
      worker: worker,
    );

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    expect(
      find.descendant(
        of: find.byType(ChatBubble),
        matching: find.byType(
          ChatBubble,
        ),
      ),
      findsNothing,
    );
    final ListView listView = widgetTester.widget(find.byType(ListView));
    expect(listView.childrenDelegate.estimatedChildCount, 0);
  });
}

void _testStreamDoNotReturnValue(MockGenAIWorker worker) {
  testWidgets(
    'given GenAIWorker stream do not update,'
    ' when load MainApp,'
    ' then show ListView 0 ChatBubbles',
    (widgetTester) async {
      // given
      when(
        () => worker.stream,
      ).thenAnswer((invocation) => const Stream.empty());

      Widget widget = MainApp(
        worker: worker,
      );

      // when
      await widgetTester.wrapAndPump(widget);

      // then
      expect(
          find.descendant(
            of: find.byType(ListView),
            matching: find.byType(ChatBubble),
          ),
          findsNothing);

      final ListView listView = widgetTester.widget(find.byType(ListView));

      expect(listView.childrenDelegate.estimatedChildCount, 0);
    },
  );
}
