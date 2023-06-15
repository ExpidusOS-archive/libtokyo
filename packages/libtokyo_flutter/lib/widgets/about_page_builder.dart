import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/libtokyo.dart';
import 'package:pubspec/pubspec.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPageBuilder extends StatelessWidget implements libtokyo.AboutPageBuilder<Key, Widget> {
  const AboutPageBuilder({
    super.key,
    required this.appTitle,
    required this.appDescription,
    required this.pubspec,
  });

  final String appTitle;
  final String appDescription;
  final PubSpec pubspec;

  List<String> get _funding {
    if (pubspec.unParsedYaml!.containsKey('funding')) {
      return (pubspec.unParsedYaml!['funding'] as List<dynamic>).map((e) => e.toString()).toList();
    }
    return <String>[];
  }

  @override
  Widget build(BuildContext context) =>
    Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 3.0,
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  appTitle,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  appDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ...(pubspec.homepage != null ? [
                  InkWell(
                    onTap: () => launchUrlString(pubspec.homepage!, mode: LaunchMode.externalApplication),
                    child: Text(
                      pubspec.homepage!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ] : []),
                Text('${pubspec.name} ${pubspec.version!}')
              ],
            ),
          ),
        ),
        ...(_funding.isNotEmpty ? [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Donations',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Column(
            children: _funding.map((link) =>
              ListTile(
                tileColor: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                shape: Theme.of(context).cardTheme.shape,
                contentPadding: Theme.of(context).cardTheme.margin,
                title: Text(
                  link,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
                onTap: () => launchUrlString(link, mode: LaunchMode.externalApplication),
              )
            ).toList(),
          )
        ] : []),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Dependencies',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Column(
          children: (pubspec.allDependencies.map((name, dep) {
            Widget? subtitle;
            if (dep is GitReference) {
              subtitle = InkWell(
                onTap: () => launchUrlString(dep.url, mode: LaunchMode.externalApplication),
                child: Text(
                  dep.url,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme
                      .of(context)
                      .colorScheme
                      .tertiary),
                ),
              );
            } else if (dep is HostedReference) {
              subtitle = InkWell(
                onTap: () =>
                    launchUrlString('https://pub.dev/packages/$name/versions/${dep.versionConstraint.toString().replaceAll('^', '')}', mode: LaunchMode.externalApplication),
                child: Text(
                  dep.versionConstraint.toString(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme
                      .of(context)
                      .colorScheme
                      .tertiary),
                ),
              );
            } else if (dep is SdkReference) {
              subtitle = Text('SDK: ${dep.sdk!}');
            }

            return MapEntry(name, ListTile(
              tileColor: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
              shape: Theme.of(context).cardTheme.shape,
              contentPadding: Theme.of(context).cardTheme.margin,
              title: Text(name),
              subtitle: subtitle,
            ));
          }).entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) => e.value).toList(),
        ),
      ],
    );
}