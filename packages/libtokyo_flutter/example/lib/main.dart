import 'package:flutter/material.dart';
import 'package:libtokyo_flutter/libtokyo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: LibTokyoThemeData.nightLight(),
          darkTheme: LibTokyoThemeData.night(),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          home: MyHomePage(themeNotifier: themeNotifier),
        );
      });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.themeNotifier});

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Flutter Demo Home Page'),
        actions: [
          SizedBox(
            height: 30,
            child: Switch(
              value: widget.themeNotifier.value != ThemeMode.light,
              onChanged: (value) {
                widget.themeNotifier.value =
                  widget.themeNotifier.value == ThemeMode.light
                    ? ThemeMode.dark : ThemeMode.light;
              },
            )
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.album),
                      title: Text('The Enchanted Nightingale'),
                      subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('BUY TICKETS'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('LISTEN'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Title 1',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          'Heading',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Title 2',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Text(
                          'Body',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Title 3',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'Caption Heading',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Title 4',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          'Caption',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ].map((e) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: e,
                  )).toList()
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
