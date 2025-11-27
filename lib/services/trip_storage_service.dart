import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../tab_two_page.dart';

class TripStorageService {
  static const String _fileName = 'trips.json';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  static Future<List<TripData>> loadTrips() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final directory = await getApplicationDocumentsDirectory();
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => TripData.fromJson(json, directory.path)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTrip(TripData trip) async {
    try {
      final trips = await loadTrips();
      trips.add(trip);
      final file = await _localFile;
      final jsonString = json.encode(trips.map((t) => t.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> saveTrips(List<TripData> trips) async {
    try {
      final file = await _localFile;
      final jsonString = json.encode(trips.map((t) => t.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> deleteTrip(int index) async {
    try {
      final trips = await loadTrips();
      if (index >= 0 && index < trips.length) {
        trips.removeAt(index);
        await saveTrips(trips);
      }
    } catch (e) {
      // Handle error
    }
  }
}

