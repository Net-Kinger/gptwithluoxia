import 'package:openai_client/openai_client.dart';

class ChatGPT extends OpenAIClient {
  late final String modelType;
  late final String token;

  ChatGPT({required this.token, this.modelType = 'text-davinci-003'})
      : super(configuration: OpenAIConfiguration(apiKey: token));
  List<String> questionsAndAnswerList = [];

  Future<void> completion({required String question}) async {
    late Completion answer;
    try {
      answer = await super
          .completions
          .create(model: modelType, prompt: question,maxTokens: 512,temperature: 0.7)
          .data;
    } catch (e) {
      questionsAndAnswerList.add(answer.choices[0].text.trimLeft());
    }
    questionsAndAnswerList.add(answer.choices[0].text.trimLeft());
  }
}
