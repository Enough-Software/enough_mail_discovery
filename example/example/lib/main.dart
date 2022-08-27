import 'package:enough_mail_discovery/enough_mail_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'enough_mail_discovery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'enough_mail_discovery Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _editingController = TextEditingController();
  var _isDiscovering = false;
  var _hasDiscovered = false;
  var _isEmailAddressValid = false;
  var _forceSslConnection = false;
  ClientConfig? _discoveredClientConfig;

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _discoveredClientConfig;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your email',
              ),
              TextField(
                controller: _editingController,
                onSubmitted:
                    _isEmailAddressValid ? (value) => _discover() : null,
                onChanged: (value) {
                  final isValid = _checkEmailAddressValidity();
                  if (isValid != _isEmailAddressValid) {
                    setState(() {
                      _isEmailAddressValid = isValid;
                    });
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'e.g. user@domain.com',
                ),
              ),
              CheckboxListTile(
                value: _forceSslConnection,
                onChanged: (value) => setState(() {
                  _forceSslConnection = value ?? false;
                }),
                title: const Text('enforce SSL'),
              ),
              if (_isDiscovering)
                const CircularProgressIndicator.adaptive()
              else
                ElevatedButton.icon(
                  onPressed: _isEmailAddressValid ? _discover : null,
                  icon: Icon(
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? CupertinoIcons.search
                        : Icons.search,
                  ),
                  label: const Text('Discover settings'),
                ),
              if (config != null)
                DiscoveredConfigViewer(config: config)
              else if (_hasDiscovered) ...[
                const SizedBox(height: 16),
                const Text('Unable to resolve settings...'),
                const SizedBox(height: 8),
                if (kIsWeb)
                  const Text('Note that enough_mail_discovery can find more '
                      'settings on non-web platforms')
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _checkEmailAddressValidity() {
    final emailAddress = _editingController.text;
    final atIndex = emailAddress.indexOf('@');
    final lastDotIndex = emailAddress.lastIndexOf('.');
    return emailAddress.length > 5 &&
        atIndex > 1 &&
        lastDotIndex > atIndex + 1 &&
        lastDotIndex < emailAddress.length - 2;
  }

  Future<void> _discover() async {
    setState(() {
      _discoveredClientConfig = null;
      _hasDiscovered = false;
      _isDiscovering = true;
    });
    final emailAddress = _editingController.text;
    final result = await Discover.discover(
      emailAddress,
      isLogEnabled: true,
      forceSslConnection: _forceSslConnection,
      isWeb: kIsWeb,
    );
    setState(() {
      _discoveredClientConfig = result;
      _isDiscovering = false;
      _hasDiscovered = true;
    });
  }
}

class DiscoveredConfigViewer extends StatelessWidget {
  const DiscoveredConfigViewer({super.key, required this.config});

  final ClientConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final incoming = config.preferredIncomingServer;
    final outgoing = config.preferredOutgoingServer;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Divider(),
        Text(config.displayName ?? '<no display name>',
            style: theme.textTheme.labelLarge),
        if (incoming != null)
          ServerConfigViewer(serverConfig: incoming, label: 'Incoming'),
        if (outgoing != null)
          ServerConfigViewer(serverConfig: outgoing, label: 'Outgoing'),
      ],
    );
  }
}

class ServerConfigViewer extends StatelessWidget {
  const ServerConfigViewer({
    super.key,
    required this.serverConfig,
    required this.label,
  });
  final ServerConfig serverConfig;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        Text(' type: ${serverConfig.typeName}'),
        Text(' host: ${serverConfig.hostname}:${serverConfig.port}'),
        Text(' socket: ${serverConfig.socketTypeName}'),
        Text(' authentication: ${serverConfig.authenticationName}'),
        Text(' username: '
            '${serverConfig.usernameType?.name ?? serverConfig.username}'),
      ],
    );
  }
}
