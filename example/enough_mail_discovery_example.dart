import 'package:enough_mail_discovery/enough_mail_discovery.dart';

// ignore: avoid_void_async
void main() async {
  const email = 'someone@enough.de';
  final config = await Discover.discover(
    email,
    isLogEnabled: false,
    forceSslConnection: false,
    isWeb: false,
  );
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
