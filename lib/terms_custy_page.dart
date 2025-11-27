import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/base_background.dart';

class TermsCustyPage extends StatefulWidget {
  const TermsCustyPage({super.key});

  @override
  State<TermsCustyPage> createState() => _TermsCustyPageState();
}

class _TermsCustyPageState extends State<TermsCustyPage> {
  late final WebViewController _controller;

  static const _termsUrl =
      'https://www.privacypolicies.com/live/5073b606-c3a2-4223-93b4-d69a6de162ca';
  static const _navHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_termsUrl));
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
                          'User Agreement',
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

