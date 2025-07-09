import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/bucket_list_item.dart';
import '../services/storage_service.dart';

class BucketListProvider extends ChangeNotifier {
  final StorageService _storage;
  List<BucketListItem> _items = [];

  BucketListProvider(this._storage) {
    _loadItems();
  }

  List<BucketListItem> get items => List.unmodifiable(_items);

  double get progress {
    if (_items.isEmpty) return 0;
    return _items.where((item) => item.isCompleted).length / _items.length;
  }

  Future<void> _loadItems() async {
    _items = await _storage.loadItems();
    notifyListeners();
  }

  Future<void> _saveItems() async {
    await _storage.saveItems(_items);
  }

  void addItem({
    required String title,
    String? description,
    DateTime? targetDate,
  }) {
    final item = BucketListItem(
      id: const Uuid().v4(),
      title: title,
      description: description,
      targetDate: targetDate,
    );
    _items.add(item);
    _saveItems();
    notifyListeners();
  }

  void updateItem(
    String id, {
    required String title,
    String? description,
    DateTime? targetDate,
  }) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = BucketListItem(
        id: id,
        title: title,
        description: description,
        targetDate: targetDate,
        isCompleted: _items[index].isCompleted,
        completedDate: _items[index].completedDate,
        photoUrl: _items[index].photoUrl,
        review: _items[index].review,
      );
      _saveItems();
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _saveItems();
    notifyListeners();
  }

  void reorderItem(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    _saveItems();
    notifyListeners();
  }

  void swapItems(String firstId, String secondId) {
    final firstIndex = _items.indexWhere((item) => item.id == firstId);
    final secondIndex = _items.indexWhere((item) => item.id == secondId);
    
    if (firstIndex != -1 && secondIndex != -1) {
      final temp = _items[firstIndex];
      _items[firstIndex] = _items[secondIndex];
      _items[secondIndex] = temp;
      _saveItems();
      notifyListeners();
    }
  }

  Future<void> toggleComplete(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = BucketListItem(
        id: item.id,
        title: item.title,
        description: item.description,
        targetDate: item.targetDate,
        isCompleted: !item.isCompleted,
        completedDate: !item.isCompleted ? DateTime.now() : null,
        photoUrl: item.photoUrl,
        review: item.review,
      );
      await _saveItems();
      notifyListeners();
    }
  }
} 