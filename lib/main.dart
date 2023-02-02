import 'package:flutter/material.dart';
import 'package:openai/utils/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _tcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatGPT _chatGPT;
  bool _needDisplayCircularIndicator = false;

  @override
  void initState() {
    super.initState();
    _chatGPT =
        ChatGPT(token: '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');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color.fromRGBO(104, 127, 165, 1),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('极为潦草的GPT(LuoXia Design)'),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _chatGPT.questionsAndAnswerList.length,
                      itemBuilder: (c, index) {
                        if (index % 2 == 0) {
                          return Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.greenAccent,
                                ),
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  _chatGPT.questionsAndAnswerList[index],
                                  style: const TextStyle(fontSize: 20),
                                )),
                          );
                        } else if (index % 2 == 1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(3.0)),
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text(
                                  _chatGPT.questionsAndAnswerList[index],
                                  style: const TextStyle(fontSize: 18),
                                )),
                          );
                        }
                      })),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "向GPT提问题",
                    hintText: "问题",
                    prefixIcon: Icon(Icons.question_mark),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_sharp),
                      onPressed: _onComplete,
                    ),
                  ),
                  controller: _tcontroller,
                  onEditingComplete: _onComplete,
                ),
              ),
            ],
          ),
          _needDisplayCircularIndicator
              ? const Positioned(child: CircularProgressIndicator())
              : const Text(""),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: const Text("清除!"),
        onPressed: () {
          setState(() {
            _chatGPT.questionsAndAnswerList.clear();
          });
        },
      ),
    );
  }

  void _onComplete() async {
    final str = _tcontroller.text;
    setState(() {
      _tcontroller.clear();
      _chatGPT.questionsAndAnswerList.add(str);
      _needDisplayCircularIndicator = true;
    });
    await _chatGPT.completion(question: str);
    setState(() {
      _needDisplayCircularIndicator = false;
    });
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
