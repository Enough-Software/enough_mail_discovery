Discover email account settings everywhere.

Available under the commercial friendly 
[MPL Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/).


## Installation
Add this dependency your _pubspec.yaml_ file:

```
dependencies:
  enough_mail_discovery: ^1.0.0
```
The latest version or `enough_mail_discovery` is [![enough_mail_discovery version](https://img.shields.io/pub/v/enough_mail_discovery.svg)](https://pub.dartlang.org/packages/enough_mail_discovery).

## Demo

Check out https://enough.de/enough_mail_discovery/ for a web demo.
Note that `enough_mail_discovery` can even detect more email setting on non-web systems that support TCP/IP Sockets.

## API Documentation
Check out the full API documentation at https://pub.dev/documentation/enough_mail_discovery/latest/

## API Usage

Just call `Discover.discover(String emailAddress)` to resolve the email address:
```dart
  /// Tries to discover mail settings for the specified [emailAddress].
  ///
  /// Optionally set [forceSslConnection] to `true` when not encrypted
  /// connections should not be allowed.
  ///
  /// Set [isLogEnabled] to `true` to output debugging information during
  /// the discovery process.
  ///
  /// Set [isWeb] to `true` when running on the web platform. Use the
  /// `kIsWeb` constant from `package:flutter/foundation.dart` when called
  /// from Flutter.
  static Future<ClientConfig?> discover(
    String emailAddress, {
    bool forceSslConnection = false,
    bool isLogEnabled = false,
    bool isWeb = false,
  }) 
```

Example for command line:
```dart
import 'package:enough_mail_discovery/enough_mail_discovery.dart';

void main() async {
  const email = 'someone@enough.de';
  final config = await Discover.discover(email, isLogEnabled: false);
  if (config == null) {
    print('Unable to discover settings for $email');
  } else {
    print('Settings for $email:');
    for (final provider in config.emailProviders!) {
      print('provider: ${provider.displayName}');
      print('provider-domains: ${provider.domains}');
      print('documentation-url: ${provider.documentationUrl}');
      print('Incoming:');
      provider.incomingServers?.forEach(print);
      print(provider.preferredIncomingServer);
      print('Outgoing:');
      provider.outgoingServers?.forEach(print);
      print(provider.preferredOutgoingServer);
    }
  }
}

```

## Tool Usage

`enough_mail_discovery` contains the `discover.dart` tool in it's example folder. After cloning the project, run
`dart example/discover.dart email@domain.com` to discover the email settings. Use the `--log` option to output more information during
the discovery process, `--ssl` to enforce SSL usage and `--preferred` to only print the preferred incoming and outgoing servers.

## Related Projects
Check out these related projects:
* [enough_mail](https://github.com/Enough-Software/enough_mail) email clients and mime message generation.
* [enough_mail_app](https://github.com/Enough-Software/enough_mail_app) aims to become a full mail app.

## Miss a feature or found a bug?

Please file feature requests and bugs at the [issue tracker](https://github.com/Enough-Software/enough_mail_discovery/issues).

## Contribute / Develop

Want to contribute? Please check out [contribute](https://github.com/Enough-Software/enough_mail_discovery/contribute).
This is an open-source community project. Anyone, even beginners, can contribute.

This is how you contribute:

* Fork the [enough_mail_discovery](https://github.com/enough-software/enough_mail_discovery/) project by pressing the fork button.
* Clone your fork to your computer: `git clone github.com/$your_username/enough_mail_discovery`
* Do your changes. When you are done, commit changes with `git add -A` and `git commit`.
* Push changes to your personal repository: `git push origin`
* Go to [enough_mail_discovery](https://github.com/enough-software/enough_mail_discovery/)  and create a pull request.


Thank you in advance!


After changing model classes, re-run the JSON serialization by calling `flutter pub run build_runner build --delete-conflicting-outputs`.

## License
`enough_mail_discovery` is licensed under the commercial friendly [Mozilla Public License 2.0](LICENSE).