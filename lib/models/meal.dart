// lib/models/meal.dart

import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
enum MealCategory {
  @HiveField(0) Breakfast,
  @HiveField(1) Lunch,
  @HiveField(2) Snack,
  @HiveField(3) Dinner,
  @HiveField(4) Other,
}

@HiveType(typeId: 1)
class Meal extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final int calories;
  @HiveField(3) final int protein;
  @HiveField(4) final int carbs;
  @HiveField(5) final int fats;
  @HiveField(6) final DateTime dateTime;
  @HiveField(7) final MealCategory category;

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.dateTime,
    required this.category,
  });
}
