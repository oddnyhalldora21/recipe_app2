import 'package:flutter/material.dart';

class RecipeCategoryList {
  final String id;
  final String name;
  final String imageUrl;

  RecipeCategoryList({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Static list of sweet treat categories
  static List<RecipeCategoryList> categories = [
    RecipeCategoryList(
      id: '1',
      name: 'Chocolate',
      imageUrl:
          'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400',
    ),
    RecipeCategoryList(
      id: '2',
      name: 'No Bake',
      imageUrl:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
    ),
    RecipeCategoryList(
      id: '3',
      name: 'Frozen',
      imageUrl:
          'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=400',
    ),
    RecipeCategoryList(
      id: '4',
      name: 'Puff Pastry',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
    ),
  ];

  // Method to get all categories
  static List<RecipeCategoryList> getAllCategories() {
    return categories;
  }

  // Method to get category by id
  static RecipeCategoryList? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
