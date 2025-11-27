import 'package:flutter/material.dart';

import 'tab_one_page.dart';
import 'widgets/base_background.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.character});

  final Character character;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  static const _reportReasons = [
    'Spam',
    'Inappropriate Content',
    'Harassment',
    'False Information',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }

    // Simulate report submission
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully'),
        backgroundColor: Color(0xFF933996),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0x33FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reason for Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._reportReasons.map((reason) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedReason = reason;
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedReason == reason
                                    ? const Color(0xFF933996)
                                    : const Color(0x80333333),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedReason == reason
                                      ? const Color(0xFFDD7BFF)
                                      : Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _selectedReason == reason
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        width: 2,
                                      ),
                                      color: _selectedReason == reason
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    child: _selectedReason == reason
                                        ? const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Color(0xFF933996),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: _selectedReason == reason
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                      const Text(
                        'Additional Details (Optional)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x80333333),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Please provide more details...',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                decoration: TextDecoration.none,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _handleSubmit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7CE3FF), Color(0xFFDD7BFF)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

