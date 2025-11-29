import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static const String _coinsKey = 'user_coins';
  static const String _initializedKey = 'coins_initialized';

  static Future<void> initializeNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    final initialized = prefs.getBool(_initializedKey) ?? false;
    if (!initialized) {
      await prefs.setInt(_coinsKey, 0);
      await prefs.setBool(_initializedKey, true);
    }
  }

  static Future<int> getCurrentCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  static Future<bool> addCoins(int coins) async {
    if (coins <= 0) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_coinsKey) ?? 0;
      await prefs.setInt(_coinsKey, currentCoins + coins);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deductCoins(int coins) async {
    if (coins <= 0) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_coinsKey) ?? 0;
      if (currentCoins < coins) {
        return false;
      }
      await prefs.setInt(_coinsKey, currentCoins - coins);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setCoins(int coins) async {
    if (coins < 0) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_coinsKey, coins);
      return true;
    } catch (e) {
      return false;
    }
  }
}

