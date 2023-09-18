import 'package:libtokyo_flutter/libtokyo.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
    const TokyoApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      themeMode: ThemeMode.dark,
    );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      windowBar: WindowBar.shouldShow(context) && !kIsWeb ? WindowBar(
        leading: Image.asset('imgs/icon.png'),
        title: const Text('libtokyo_example'),
      ) : null,
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.chevronDown),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Null'),
              ),
            ],
          ),
        ],
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
      body: ListView(
        children: [
          ListTile(
            title: const Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Item 3'),
            value: _value,
            onChanged: (value) =>
              setState(() {
                _value = value!;
              }),
          ),
          SwitchListTile(
            title: const Text('Item 4'),
            value: !_value,
            onChanged: (value) =>
              setState(() {
                _value = !(value!);
              }),
          ),
        ],
      ),
    );
}
