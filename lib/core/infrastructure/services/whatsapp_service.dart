import 'dart:io';

import 'package:debs_driver_app/core/domain/value_objects/phone.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@LazySingleton()
abstract class WhatsappService {
  WhatsappService();

  @factoryMethod
  factory WhatsappService.create() =>
      Platform.isIOS ? IOSWhatsappService() : AndroidWhatsappService();

  final message = "Hello, I need help!";

  Future<bool> openWhatsapp(Phone phone);

  Future<void> openStore(Phone phone);
}

class AndroidWhatsappService extends WhatsappService {
  AndroidWhatsappService();

  @override
  Future<void> openStore(Phone phone) async {
    await launchUrl(Uri.parse('https://api.whatsapp.com/send?phone=$phone&text=$message'));
  }

  @override
  Future<bool> openWhatsapp(Phone phone) async {
    try {
      final schemes = [
        'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}',
        'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
        'https://api.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(message)}',
      ];

      for (String scheme in schemes) {
        final uri = Uri.parse(scheme);
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (launched) return true;
        }
      }

      // If none worked, open store
      await openStore(phone);
      return false;
    } catch (e) {
      await openStore(phone);
      return false;
    }
  }
}

class IOSWhatsappService extends WhatsappService {
  IOSWhatsappService();

  @override
  Future<bool> openWhatsapp(Phone phone) async {
    try {
      // Try multiple URL schemes for iOS
      final schemes = [
        'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}',
        'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
      ];

      for (String scheme in schemes) {
        final uri = Uri.parse(scheme);
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (launched) return true;
        }
      }

      // If none worked, open store
      await openStore(phone);
      return false;
    } catch (e) {
      await openStore(phone);
      return false;
    }
  }

  @override
  Future<void> openStore(Phone phone) async {
    await launchUrl(
      Uri.parse('https://apps.apple.com/us/app/whatsapp-messenger/id310633997'),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }
}
