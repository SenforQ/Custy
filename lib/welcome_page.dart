import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'privacy_policy_custy_page.dart';
import 'terms_custy_page.dart';

typedef WelcomeEnterCallback = void Function(BuildContext context);

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.onEnter});

  final WelcomeEnterCallback onEnter;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _agreed = false;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _handleEnter() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms before entering.'),
          backgroundColor: Color(0xFFB678F8),
        ),
      );
      return;
    }
    widget.onEnter(context);
  }

  void _openTerms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TermsCustyPage(),
      ),
    );
  }

  void _openPrivacy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyCustyPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/welcome_custy_bg.webp',
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                     GestureDetector(
                    onTap: _handleEnter,
                    child: Container(
                      width: size.width - 40,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C191D),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Enter App',
                        style: TextStyle(
                          color: Color(0xFFB678F8),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Checkbox(
                          value: _agreed,
                          onChanged: (value) {
                            setState(() {
                              _agreed = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFB678F8),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.white70, width: 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              height: 1.4,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'I have carefully read and agree to the ',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  color: Color(0xFFA355F6),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFA355F6),
                                ),
                                recognizer: _termsRecognizer,
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Color(0xFFA355F6),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFA355F6),
                                ),
                                recognizer: _privacyRecognizer,
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
             
                  const SizedBox(height: 12),
                  Text(
                    'Please review the agreements before continuing.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

