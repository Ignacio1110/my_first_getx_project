import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolateExample extends StatelessWidget {
  const IsolateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      title: 'isolate example',
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _heavyWorkResult = 0;

  void _incrementCounter() async {
    int result = await compute(_heavyWork, _counter * 5000000);
    setState(() {
      _counter++;
      _heavyWorkResult = result;
    });
  }

  static int _heavyWork(int num) {
    int i = 0;
    while (num-- > 0) {
//       print(num);
      i += num;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_heavyWorkResult\nYou have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
