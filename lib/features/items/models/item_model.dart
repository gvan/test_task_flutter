import 'package:flutter/foundation.dart';

@immutable
class ItemModel {
  const ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.colorValue,
    required this.iconCodePoint,
    this.favorite = false,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int colorValue;
  final int iconCodePoint;
  final bool favorite;

  ItemModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? rating,
    int? colorValue,
    int? iconCodePoint,
    bool? favorite,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      favorite: favorite ?? this.favorite,
    );
  }
}
