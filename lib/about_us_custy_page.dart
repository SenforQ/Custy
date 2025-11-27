import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widgets/base_background.dart';

class AboutUsCustyPage extends StatefulWidget {
  const AboutUsCustyPage({super.key});

  @override
  State<AboutUsCustyPage> createState() => _AboutUsCustyPageState();
}

class _AboutUsCustyPageState extends State<AboutUsCustyPage> {
  String _appName = 'Custy';
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appName = packageInfo.appName.isEmpty ? 'Custy' : packageInfo.appName;
      _version = '${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseBackground(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: statusBarHeight, left: 8, right: 8),
              height: statusBarHeight + 56,
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
                        'About Us',
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/app_logo.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Version $_version',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

