// lib/models/standard_meal.dart
import 'meal.dart';

class StandardMeal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final MealCategory category;

  StandardMeal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.category,
  });

  factory StandardMeal.fromJson(Map<String, dynamic> json) {
    return StandardMeal(
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fats: json['fats'],
      category: MealCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == (json['category'] as String).toLowerCase(),
        orElse: () => MealCategory.Other,
      ),
    );
  }

  Meal toMeal() {
    return Meal(
      id: DateTime.now().toString(),
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      dateTime: DateTime.now(),
      category: category,
    );
  }
}
