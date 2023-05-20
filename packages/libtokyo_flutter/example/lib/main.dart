import 'package:libtokyo_flutter/libtokyo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
    TokyoApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
    );
}
