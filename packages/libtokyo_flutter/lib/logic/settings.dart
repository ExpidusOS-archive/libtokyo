import 'package:shared_preferences/shared_preferences.dart';

abstract class Settings<T> {
  const Settings(this.defaultValue);

  String get name;
  final T defaultValue;
  T valueFor(SharedPreferences prefs) => (prefs.get(name) as T?) ?? defaultValue;
  Future<T> get value async => valueFor(await SharedPreferences.getInstance());

  @override
  toString() => '$name:${T.toString()}';
}