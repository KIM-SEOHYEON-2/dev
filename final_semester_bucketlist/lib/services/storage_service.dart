import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import '../models/bucket_list_item.dart';

class StorageService {
  static final _logger = Logger('StorageService');
  static const String _key = 'bucket_list_items';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<List<BucketListItem>> loadItems() async {
    try {
      final String? jsonString = _prefs.getString(_key);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) {
        try {
          return BucketListItem.fromJson(json);
        } catch (e) {
          _logger.warning('Error parsing item: $e');
          return null;
        }
      }).whereType<BucketListItem>().toList();
    } catch (e) {
      _logger.severe('Error loading items: $e');
      return [];
    }
  }

  Future<bool> saveItems(List<BucketListItem> items) async {
    try {
      final String jsonString = json.encode(
        items.map((item) => item.toJson()).toList(),
      );
      return await _prefs.setString(_key, jsonString);
    } catch (e) {
      _logger.severe('Error saving items: $e');
      return false;
    }
  }
} 