import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class BlockedUsersService {
  static const _fileName = 'blocked_users.json';

  static Future<File> _localFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static Future<Set<String>> _loadBlockedUsers() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        return <String>{};
      }
      final contents = await file.readAsString();
      final jsonMap = json.decode(contents) as Map<String, dynamic>;
      final blockedList = (jsonMap['blocked'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList();
      final mutedList = (jsonMap['muted'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList();
      return {...blockedList, ...mutedList};
    } catch (_) {
      return <String>{};
    }
  }

  static Future<Set<String>> getBlockedUsers() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        return <String>{};
      }
      final contents = await file.readAsString();
      final jsonMap = json.decode(contents) as Map<String, dynamic>;
      return (jsonMap['blocked'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  static Future<Set<String>> getMutedUsers() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        return <String>{};
      }
      final contents = await file.readAsString();
      final jsonMap = json.decode(contents) as Map<String, dynamic>;
      return (jsonMap['muted'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  static Future<void> _saveBlockedUsers(
      Set<String> blocked, Set<String> muted) async {
    try {
      final file = await _localFile();
      final jsonMap = {
        'blocked': blocked.toList(),
        'muted': muted.toList(),
      };
      await file.writeAsString(json.encode(jsonMap));
    } catch (_) {
      // ignore write errors for now
    }
  }

  static Future<void> blockUser(String nickName) async {
    final blocked = await getBlockedUsers();
    final muted = await getMutedUsers();
    blocked.add(nickName);
    await _saveBlockedUsers(blocked, muted);
  }

  static Future<void> muteUser(String nickName) async {
    final blocked = await getBlockedUsers();
    final muted = await getMutedUsers();
    muted.add(nickName);
    await _saveBlockedUsers(blocked, muted);
  }

  static Future<void> unblockUser(String nickName) async {
    final blocked = await getBlockedUsers();
    final muted = await getMutedUsers();
    blocked.remove(nickName);
    await _saveBlockedUsers(blocked, muted);
  }

  static Future<void> unmuteUser(String nickName) async {
    final blocked = await getBlockedUsers();
    final muted = await getMutedUsers();
    muted.remove(nickName);
    await _saveBlockedUsers(blocked, muted);
  }

  static Future<bool> isUserBlockedOrMuted(String nickName) async {
    final allBlocked = await _loadBlockedUsers();
    return allBlocked.contains(nickName);
  }
}

