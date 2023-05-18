import 'package:libtokyo/widgets.dart' as libtokyo;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show MaterialScrollBehavior, MaterialApp, Colors;

class TokyoApp extends StatefulWidget with libtokyo.TokyoApp<Widget> {
  const TokyoApp({
    super.key,
    super.home,
    super.title,
    this.scrollBehavior,
  });

  final ScrollBehavior? scrollBehavior;

  @override
  State<TokyoApp> createState() => _TokyoAppState();
}

class _TokyoAppState extends State<TokyoApp> {
  late HeroController _heroController;

  @override
  void initState() {
    super.initState();
    _heroController = MaterialApp.createMaterialHeroController();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const MaterialScrollBehavior(),
      child: HeroControllerScope(
        controller: _heroController,
        child: WidgetsApp(
          key: GlobalObjectKey(this),
          color: Colors.white,
          home: widget.home,
          title: widget.title,
        ),
      ),
    );
  }
}
