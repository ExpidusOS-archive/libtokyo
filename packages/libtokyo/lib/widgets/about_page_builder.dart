import 'package:meta/meta.dart';
import 'package:pubspec/pubspec.dart';

@immutable
abstract class AboutPageBuilder<Key, Widget extends Object> {
  const AboutPageBuilder({
    this.key,
    required this.appTitle,
    required this.appDescription,
    required this.pubspec,
  });

  final Key? key;
  final String appTitle;
  final String appDescription;
  final PubSpec pubspec;
}