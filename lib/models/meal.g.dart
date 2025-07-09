// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 1;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: fields[2] as int,
      protein: fields[3] as int,
      carbs: fields[4] as int,
      fats: fields[5] as int,
      dateTime: fields[6] as DateTime,
      category: fields[7] as MealCategory,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fats)
      ..writeByte(6)
      ..write(obj.dateTime)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealCategoryAdapter extends TypeAdapter<MealCategory> {
  @override
  final int typeId = 0;

  @override
  MealCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MealCategory.Breakfast;
      case 1:
        return MealCategory.Lunch;
      case 2:
        return MealCategory.Snack;
      case 3:
        return MealCategory.Dinner;
      case 4:
        return MealCategory.Other;
      default:
        return MealCategory.Breakfast;
    }
  }

  @override
  void write(BinaryWriter writer, MealCategory obj) {
    switch (obj) {
      case MealCategory.Breakfast:
        writer.writeByte(0);
        break;
      case MealCategory.Lunch:
        writer.writeByte(1);
        break;
      case MealCategory.Snack:
        writer.writeByte(2);
        break;
      case MealCategory.Dinner:
        writer.writeByte(3);
        break;
      case MealCategory.Other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
