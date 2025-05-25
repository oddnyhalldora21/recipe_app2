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

  static List<RecipeCategoryList> categories = [
    RecipeCategoryList(
      id: '1',
      name: 'Chocolate',
      imageUrl:
          'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400&h=400&fit=crop',
    ),
    RecipeCategoryList(
      id: '2',
      name: 'Gluten Free',
      imageUrl:
          'https://myquietkitchen.com/wp-content/uploads/2019/10/healthy-banana-brownies-vegan-oil-free-no-eggs-2.jpg',
    ),
    RecipeCategoryList(
      id: '3',
      name: 'Cookies',
      imageUrl:
          'https://sallysbakingaddiction.com/wp-content/uploads/2013/05/classic-chocolate-chip-cookies.jpg',
    ),
    RecipeCategoryList(
      id: '4',
      name: 'Vegan',
      imageUrl:
          'https://hips.hearstapps.com/hmg-prod/images/cranberry-vegan-cheesecakes-1-680x1020at2x-1590604698.jpg',
    ),
    RecipeCategoryList(
      id: '5',
      name: 'Frozen',
      imageUrl:
          'https://gourmandeinthekitchen.com/wp-content/uploads/2017/07/Raw-Chocolate-Fudge-Popsicles-590x885.jpg',
    ),

    RecipeCategoryList(
      id: '6',
      name: 'No Bake',
      imageUrl:
          'https://sundaytable.co/wp-content/uploads/2023/08/easy-strawberry-crunch-cheeseacke.jpg',
    ),

    RecipeCategoryList(
      id: '7',
      name: 'No Sugar',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiRjt4A-TRZSmORiY_YiHwruO-I1TBpw42A&s',
    ),
  ];

  static List<RecipeCategoryList> getAllCategories() {
    return categories;
  }

  static RecipeCategoryList? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static RecipeCategoryList? getCategoryByName(String name) {
    try {
      return categories.firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
