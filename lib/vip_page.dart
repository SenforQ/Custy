import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/toast_utils.dart';
import 'widgets/base_background.dart';

class VipProduct {
  final String productId;
  final String period;
  final double price;
  final String priceText;

  VipProduct({
    required this.productId,
    required this.period,
    required this.price,
    required this.priceText,
  });
}

final List<VipProduct> kVipProducts = [
  VipProduct(
    productId: 'CustyWeekVIP',
    period: 'Per week',
    price: 12.99,
    priceText: '\$12.99',
  ),
  VipProduct(
    productId: 'CustyMonthVIP',
    period: 'Per month',
    price: 49.99,
    priceText: '\$49.99',
  ),
];

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  bool _isWeeklySelected = true;
  bool _isVipActive = false;
  Map<String, bool> _loadingStates = {};
  Map<String, Timer> _timeoutTimers = {};
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  Map<String, ProductDetails> _products = {};
  int _retryCount = 0;
  static const int maxRetries = 3;
  static const int timeoutDuration = 30;

  void _handleTimeout(String productId) {
    if (mounted) {
      setState(() {
        _loadingStates[productId] = false;
      });

      _timeoutTimers[productId]?.cancel();
      _timeoutTimers.remove(productId);

      try {
        showCenterToast(context, 'Payment timeout. Please try again.');
      } catch (e) {
        print('Failed to show timeout toast: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVipStatus();
    _checkConnectivityAndInit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    for (final timer in _timeoutTimers.values) {
      timer.cancel();
    }
    _timeoutTimers.clear();
    super.dispose();
  }

  Future<void> _checkConnectivityAndInit() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showCenterToast(
        context,
        'No internet connection. Please check your network settings.',
      );
      return;
    }
    await _initIAP();
  }

  Future<void> _initIAP() async {
    try {
      final available = await _inAppPurchase.isAvailable();
      if (!mounted) return;
      setState(() {
        _isAvailable = available;
      });
      if (!available) {
        if (mounted) {
          showCenterToast(context, 'In-App Purchase not available');
        }
        return;
      }
      final Set<String> _kIds = kVipProducts.map((e) => e.productId).toSet();
      final response = await _inAppPurchase.queryProductDetails(_kIds);
      if (response.error != null) {
        if (_retryCount < maxRetries) {
          _retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          await _initIAP();
          return;
        }
        showCenterToast(
          context,
          'Failed to load products: ${response.error!.message}',
        );
      }
      setState(() {
        _products = {for (var p in response.productDetails) p.id: p};
      });
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (e) {
          if (mounted) {
            showCenterToast(context, 'Purchase error: ${e.toString()}');
          }
        },
      );
    } catch (e) {
      if (_retryCount < maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        await _initIAP();
      } else {
        if (mounted) {
          showCenterToast(
            context,
            'Failed to initialize in-app purchases. Please try again later.',
          );
        }
      }
    }
  }

  Future<void> _loadVipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVipActive = prefs.getBool('user_vip_active') ?? false;
    });
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _inAppPurchase.completePurchase(purchase);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('user_vip_active', true);

        if (mounted) {
          setState(() {
            _isVipActive = true;
          });

          try {
            showCenterToast(
              context,
              'VIP subscription activated successfully!',
            );
          } catch (e) {
            print('Failed to show success toast: $e');
          }

          await Future.delayed(const Duration(milliseconds: 1500));
          if (mounted) {
            try {
              Navigator.of(context).pop(true);
            } catch (e) {
              print('Failed to navigate back: $e');
            }
          }
        }
      } else if (purchase.status == PurchaseStatus.error) {
        if (mounted) {
          try {
            showCenterToast(
              context,
              'Purchase failed: ${purchase.error?.message ?? ''}',
            );
          } catch (e) {
            print('Failed to show error toast: $e');
          }
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        if (mounted) {
          try {
            showCenterToast(context, 'Purchase canceled.');
          } catch (e) {
            print('Failed to show cancel toast: $e');
          }
        }
      }

      if (mounted) {
        setState(() {
          _loadingStates.clear();
        });

        for (final timer in _timeoutTimers.values) {
          timer.cancel();
        }
        _timeoutTimers.clear();
      }
    }
  }

  Future<void> _handlePurchase(VipProduct vipProduct) async {
    if (!_isAvailable) {
      showCenterToast(context, 'Store is not available');
      return;
    }

    setState(() {
      _loadingStates[vipProduct.productId] = true;
    });

    _timeoutTimers[vipProduct.productId] = Timer(
      Duration(seconds: timeoutDuration),
      () => _handleTimeout(vipProduct.productId),
    );

    try {
      final product = _products[vipProduct.productId];

      ProductDetails? productToUse = product;
      if (productToUse == null && _products.isNotEmpty) {
        productToUse = _products.values.first;
      }

      if (productToUse == null) {
        throw Exception('No products available for purchase');
      }

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productToUse);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _timeoutTimers[vipProduct.productId]?.cancel();
      _timeoutTimers.remove(vipProduct.productId);

      if (mounted) {
        showCenterToast(context, 'Purchase failed: ${e.toString()}');
      }
      setState(() {
        _loadingStates[vipProduct.productId] = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    if (!_isAvailable) {
      showCenterToast(context, 'Store is not available');
      return;
    }

    try {
      await _inAppPurchase.restorePurchases();
      showCenterToast(context, 'Restoring purchases...');
    } catch (e) {
      if (mounted) {
        showCenterToast(context, 'Restore failed: ${e.toString()}');
      }
    }
  }

  Future<void> _handleConfirmPurchase() async {
    if (!_isAvailable) {
      showCenterToast(context, 'Store is not available');
      return;
    }

    final selectedProduct =
        _isWeeklySelected ? kVipProducts[0] : kVipProducts[1];

    setState(() {
      _loadingStates[selectedProduct.productId] = true;
    });

    _timeoutTimers[selectedProduct.productId] = Timer(
      Duration(seconds: timeoutDuration),
      () => _handleTimeout(selectedProduct.productId),
    );

    try {
      final product = _products[selectedProduct.productId];

      ProductDetails? productToUse = product;
      if (productToUse == null && _products.isNotEmpty) {
        productToUse = _products.values.first;
      }

      if (productToUse == null) {
        throw Exception('No products available for purchase');
      }

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productToUse);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _timeoutTimers[selectedProduct.productId]?.cancel();
      _timeoutTimers.remove(selectedProduct.productId);

      if (mounted) {
        showCenterToast(context, 'Purchase failed: ${e.toString()}');
      }
      setState(() {
        _loadingStates[selectedProduct.productId] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: statusBarHeight > 0 ? 0 : 8,
                      left: 8,
                      right: 8,
                    ),
                    height: statusBarHeight + 56,
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
                        const Expanded(
                          child: Center(
                            child: Text(
                              'VIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showVipInfo(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0x33FFFFFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isVipActive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF9E9E9E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isVipActive ? 'VIP ACTIVE' : 'VIP INACTIVE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Member benefits',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isVipActive) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x804CAF50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF4CAF50),
                                    size: 48,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'VIP Subscription Active',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'You are currently enjoying all VIP benefits',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _SubscriptionCard(
                                    isSelected: _isWeeklySelected,
                                    onTap: () =>
                                        setState(() => _isWeeklySelected = true),
                                    productId: kVipProducts[0].productId,
                                    price: kVipProducts[0].price,
                                    period: kVipProducts[0].period,
                                    totalPrice: kVipProducts[0].price,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SubscriptionCard(
                                    isSelected: !_isWeeklySelected,
                                    onTap: () =>
                                        setState(() => _isWeeklySelected = false),
                                    productId: kVipProducts[1].productId,
                                    price: kVipProducts[1].price,
                                    period: kVipProducts[1].period,
                                    totalPrice: kVipProducts[1].price,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 32),
                          const Text(
                            'Exclusive VIP Privileges',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _VipPrivilegeItem(
                            icon: Icons.person,
                            title: 'Unlimited avatar changes',
                            description: 'VIPs can change avatars without limits',
                          ),
                          const SizedBox(height: 12),
                          _VipPrivilegeItem(
                            icon: Icons.block,
                            title: 'Eliminate in-app advertising',
                            description: 'VIPs can get rid of ads',
                          ),
                          const SizedBox(height: 12),
                          _VipPrivilegeItem(
                            icon: Icons.view_list,
                            title: 'Unlimited Avatar list views',
                            description: 'VIPs can view avatar lists endlessly',
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (!_isVipActive) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleConfirmPurchase,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF933996),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _restorePurchases,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFFE66EA),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Restore',
                              style: TextStyle(
                                color: Color(0xFFFE66EA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_loadingStates.values.any((loading) => loading))
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF933996)),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showVipInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'VIP Subscription',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDD7BFF),
            ),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VIP Benefits:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Unlimited avatar changes',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'No in-app advertisements',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Unlimited avatar list views',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: Color(0xFFDD7BFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.isSelected,
    required this.onTap,
    required this.productId,
    required this.price,
    required this.period,
    required this.totalPrice,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String productId;
  final double price;
  final String period;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x80FE66EA)
              : const Color(0x80333333),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFE66EA)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'USD${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VipPrivilegeItem extends StatelessWidget {
  const _VipPrivilegeItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x80333333),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFE66EA),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0x80FE66EA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDD7BFF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
