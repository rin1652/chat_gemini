import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat_with_gemini_in_flutter/data/chat_content.dart';
import 'package:public_chat_with_gemini_in_flutter/worker/gen_a_i_worker.dart';

class MockGenerativeModel extends Mock implements GenerativeModelWrapper {}

void main() {
  final MockGenerativeModel model = MockGenerativeModel();

  /// test case AI response 'Gemini not response...'
  _testGeminiResponseNull(model);

  /// test case AI response 'Gemini success'
  _testGeminiResponseAvailable(model);

  /// test case don't send message to 'Gemini'
  _testGeminiResponseNoSendMessSuccess(model);
}

void _testGeminiResponseNull(MockGenerativeModel model) {
  return test(
    "given generateContent response success , and text is null"
    'when sendToGemini,'
    'then return preset response',
    () async {
      final GenAIWorker genAIWorker = GenAIWorker(wrapper: model);

      // sau khi gửi xong rồi thì phải kiểm tra cái stream xem nó có trả về kết quả như mong muốn không

      List<ChatContent> contents = [];
      final StreamSubscription subscription =
          genAIWorker.stream.listen((event) {
        contents = event;
      });

      // given dùng when để mock những reponse mà mình mong muốn.
      // khi gọi model generateContent thì sẽ trả về một giá trị mà mình mong muốn
      // ở đây return về Future.value(GenerateContentResponse),);
      when(
        () => model.generateContent(any()),
      ).thenAnswer(
        (invocation) => Future.value(
          GenerateContentResponse(
            [
              Candidate(
                Content('user', []),
                null,
                null,
                null,
                null,
              )
            ],
            null,
          ),
        ),
      );

      // when
      await genAIWorker.sendToGemini('This is ny message');

      // then
      // chúng ta sẽ kiểu tra length của contents xem nó có bằng 2 không
      // vì lần 1 chúng ta sẽ add content của user vào (người dùng chat với AI)
      // lần 2 thì AI sẽ trả về 1 content nên sẽ check xem có đúng là trả về 2 không?
      expect(contents.length, 2);
      // check có phải sender đầu tiên là user không?
      // check có phải mess đầu tiên là "This is ny message" không?
      expect(contents.first.sender, Sender.user);
      expect(contents.first.message, "This is ny message");

      // check sender thứ 2 có phải là gemini không?
      // check có phải mess thứ hai là: "Gemini error..." không?
      expect(contents.last.sender, Sender.gemini);
      expect(contents.last.message, "Gemini not response...");

      subscription.cancel();
    },
  );
}

void _testGeminiResponseAvailable(MockGenerativeModel model) {
  return test(
      "given generateContent response success , and text is not null"
      "when sendToGemini,"
      "then return responded text", () async {
    final GenAIWorker worker = GenAIWorker(wrapper: model);

    List<ChatContent> contents = [];
    final StreamSubscription subscription = worker.stream.listen((event) {
      contents = event;
    });

    // given
    // use send mess for AI
    // when sử dụng generateContent với input là bất cứ thứ gì
    // thenAnswer mong muốn trả về cái gì thì điền vào đây
    // the content của candidate sẽ trả về một TextPart là ....
    when(
      () => model.generateContent(any()),
    ).thenAnswer(
      (invocation) => Future.value(
        GenerateContentResponse(
          [
            Candidate(
              Content.model(
                [
                  TextPart('This is a message from AI'),
                  // TextPart('This is a message from 2'),
                ],
              ),
              null,
              null,
              null,
              null,
            ),
          ],
          null,
        ),
      ),
    );

    // when
    await worker.sendToGemini('This is ny message');
    //then
    expect(contents.length, 2);
    //first list
    expect(contents.first.sender, Sender.user);
    expect(contents.first.message, 'This is ny message');

    // second list
    expect(contents[1].sender, Sender.gemini);
    expect(contents[1].message, 'This is a message from AI');

    subscription.cancel();
  });
}

void _testGeminiResponseNoSendMessSuccess(MockGenerativeModel model) {
  final GenAIWorker worker = GenAIWorker(wrapper: model);
  return test(
    "given generateContent response not success , and text is not null"
    "when sendToGemini,"
    "then return Gemini error",
    () async {
      List<ChatContent> contents = [];
      StreamSubscription subscription = worker.stream.listen((event) {
        contents = event;
      });

      when(
        () => model.generateContent(any()),
      ).thenThrow(Exception('anything ....'));

      // send mess
      await worker.sendToGemini('This is my message');
      //test response first
      expect(contents.first.sender, Sender.user);
      expect(contents.first.message, 'This is my message');
      //test response second
      expect(contents[1].sender, Sender.gemini);
      expect(contents[1].message, 'Gemini error...');

      subscription.cancel();
    },
  );
}
