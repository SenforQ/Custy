import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UserMetricsService {
  static const _fileName = 'app_start_timestamp.txt';

  static Future<DateTime> getOrCreateAppStartDate() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    if (await file.exists()) {
      final content = await file.readAsString();
      final timestamp = int.tryParse(content);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    }

    final now = DateTime.now();
    await file.writeAsString(now.millisecondsSinceEpoch.toString());
    return now;
  }
}

