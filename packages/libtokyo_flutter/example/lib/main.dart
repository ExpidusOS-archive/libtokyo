import 'package:libtokyo_flutter/libtokyo.dart';
import 'package:flutter/material.dart';
import 'dart:io' show exit;

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
      appBar: PreferredSize(
        child: Column(
          children: [
            WindowBar(
              leading: Image.asset('imgs/icon.png'),
              title: const Text('libtokyo_example'),
            ),
            AppBar(
              title: const Text('Flutter Demo'),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(AppBar.preferredHeightFor(context, Size.fromHeight(kToolbarHeight)) * 1.5),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Text('Hello, world'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
}
