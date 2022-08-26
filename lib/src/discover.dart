import 'discover_helper.dart';

import 'client_config.dart';

/// Helps discovering email connection settings based on an email address.
///
/// Use [discover] to initiate the discovery process.
class Discover {
  Discover._();

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
  }) async {
    final config = await _discover(
      emailAddress,
      isLogEnabled: isLogEnabled,
      isWeb: isWeb,
    );
    if (forceSslConnection && config != null) {
      if (config.preferredIncomingImapServer != null &&
          !config.preferredIncomingImapServer!.isSecureSocket) {
        config.preferredIncomingImapServer!.port = 993;
        config.preferredIncomingImapServer!.socketType = SocketType.ssl;
      }
      if (config.preferredIncomingPopServer != null &&
          !config.preferredIncomingPopServer!.isSecureSocket) {
        config.preferredIncomingPopServer!.port = 995;
        config.preferredIncomingPopServer!.socketType = SocketType.ssl;
      }
      if (config.preferredOutgoingSmtpServer != null &&
          !config.preferredOutgoingSmtpServer!.isSecureSocket) {
        config.preferredOutgoingSmtpServer!.port = 465;
        config.preferredOutgoingSmtpServer!.socketType = SocketType.ssl;
      }
    }
    return config;
  }

  static Future<ClientConfig?> _discover(
    String emailAddress, {
    required bool isLogEnabled,
    required bool isWeb,
  }) async {
    // [1] auto-discover from sub-domain,
    // compare: https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration
    final emailDomain = DiscoverHelper.getDomainFromEmail(emailAddress);
    var config = await DiscoverHelper.discoverFromAutoConfigSubdomain(
      emailAddress,
      domain: emailDomain,
      isLogEnabled: isLogEnabled,
    );
    if (config == null) {
      final mxDomain = await DiscoverHelper.discoverMxDomain(emailDomain);
      _log('mxDomain for [$emailDomain] is [$mxDomain]', isLogEnabled);
      if (mxDomain != null && mxDomain != emailDomain) {
        config = await DiscoverHelper.discoverFromAutoConfigSubdomain(
          emailAddress,
          domain: mxDomain,
          isLogEnabled: isLogEnabled,
        );
      }
      //print('querying ISP DB for $mxDomain');

      // [5] auto-discover from Mozilla ISP DB:
      // https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration
      final hasMxDomain = mxDomain != null && mxDomain != emailDomain;
      config ??= await DiscoverHelper.discoverFromIspDb(
        emailDomain,
        isLogEnabled: isLogEnabled,
      );
      if (hasMxDomain) {
        config ??= await DiscoverHelper.discoverFromIspDb(
          mxDomain,
          isLogEnabled: isLogEnabled,
        );
      }

      // try to guess incoming and outgoing server names based on the domain,
      // but only only on platforms that support sockets:
      if (!isWeb) {
        final domains = hasMxDomain ? [emailDomain, mxDomain] : [emailDomain];
        config ??= await DiscoverHelper.discoverFromCommonDomains(
          domains,
          isLogEnabled: isLogEnabled,
        );
      }
    }
    //print('got config $config for $mxDomain.');
    return _updateDisplayNames(config, emailDomain);
  }

  static ClientConfig? _updateDisplayNames(
      ClientConfig? config, String mailDomain) {
    final emailProviders = config?.emailProviders;
    if (emailProviders != null && emailProviders.isNotEmpty) {
      for (final provider in emailProviders) {
        if (provider.displayName != null) {
          provider.displayName =
              provider.displayName!.replaceFirst('%EMAILDOMAIN%', mailDomain);
        }
        if (provider.displayShortName != null) {
          provider.displayShortName = provider.displayShortName!
              .replaceFirst('%EMAILDOMAIN%', mailDomain);
        }
      }
    }
    return config;
  }

  static void _log(String text, bool isLogEnabled) {
    if (isLogEnabled) {
      print(text);
    }
  }
}
