import 'package:flutter/foundation.dart';

@immutable
class BucketListItem {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? completedDate;
  final DateTime? targetDate;
  final String? photoUrl;
  final String? review;

  BucketListItem({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.completedDate,
    this.targetDate,
    this.photoUrl,
    this.review,
  });

  BucketListItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? completedDate,
    bool? isCompleted,
    String? photoUrl,
    String? review,
  }) {
    return BucketListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completedDate: completedDate ?? this.completedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      photoUrl: photoUrl ?? this.photoUrl,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'completedDate': completedDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'photoUrl': photoUrl,
      'review': review,
    };
  }

  factory BucketListItem.fromJson(Map<String, dynamic> json) {
    return BucketListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool,
      photoUrl: json['photoUrl'] as String?,
      review: json['review'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BucketListItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completedDate == completedDate &&
        other.isCompleted == isCompleted &&
        other.photoUrl == photoUrl &&
        other.review == review;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      completedDate,
      isCompleted,
      photoUrl,
      review,
    );
  }
} 