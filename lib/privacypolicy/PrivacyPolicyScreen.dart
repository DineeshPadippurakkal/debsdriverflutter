import 'package:debs_driver_app/Utils/color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacypolicyscreen extends StatefulWidget {
  const Privacypolicyscreen({super.key});

  @override
  State<Privacypolicyscreen> createState() => _PrivacypolicyscreenState();
}

class _PrivacypolicyscreenState extends State<Privacypolicyscreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          'https://allowmena.com/app-privacy',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text("Privacy Policy",style: TextStyle(color: Colors.white),),
        backgroundColor: ColorTheme().colorPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
