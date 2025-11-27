import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/base_background.dart';

class PrivacyPolicyCustyPage extends StatefulWidget {
  const PrivacyPolicyCustyPage({super.key});

  @override
  State<PrivacyPolicyCustyPage> createState() => _PrivacyPolicyCustyPageState();
}

class _PrivacyPolicyCustyPageState extends State<PrivacyPolicyCustyPage> {
  late final WebViewController _controller;

  static const _privacyUrl =
      'https://www.privacypolicies.com/live/becc2c16-8e6e-42dc-9779-703e8b317d40';
  static const _navHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_privacyUrl));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final contentHeight =
        mediaQuery.size.height - statusBarHeight - _navHeight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseBackground(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: statusBarHeight + _navHeight,
              child: Container(
                padding: EdgeInsets.only(top: statusBarHeight),
                color: Colors.transparent,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Positioned(
              top: statusBarHeight + _navHeight,
              left: 0,
              right: 0,
              height: contentHeight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: WebViewWidget(controller: _controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

