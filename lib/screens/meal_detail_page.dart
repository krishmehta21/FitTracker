// lib/screens/meal_detail_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/standard_meal.dart';
import '../models/meal.dart';

class MealDetailPage extends StatefulWidget {
  final StandardMeal standardMeal;
  const MealDetailPage({required this.standardMeal, super.key});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  double _servings = 1.0;
  late int _cal, _prot, _carb, _fat;
  bool _saveToFavorites = false;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  void _recalc() {
    final m = widget.standardMeal;
    _cal = (m.calories * _servings).round();
    _prot = (m.protein * _servings).round();
    _carb = (m.carbs * _servings).round();
    _fat = (m.fats * _servings).round();
  }

  Future<void> _onAdd() async {
    final meal = Meal(
      id: DateTime.now().toString(),
      name: widget.standardMeal.name,
      calories: _cal,
      protein: _prot,
      carbs: _carb,
      fats: _fat,
      dateTime: DateTime.now(),
      category: widget.standardMeal.category,
    );

    final mealBox = Hive.box<Meal>('meals');
    await mealBox.add(meal);

    if (_saveToFavorites) {
      final savedBox = Hive.box<Meal>('saved_meals');
      await savedBox.add(meal);
    }

    debugPrint('Added meal: ${meal.name} ($_servings servings)');
    debugPrint('Calories: ${meal.calories}, Protein: ${meal.protein}, Carbs: ${meal.carbs}, Fats: ${meal.fats}');
    debugPrint('Saved to favorites: $_saveToFavorites');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${meal.name} added to today!')),
      );
    }

    Navigator.pop(context); // just pop, no data returned
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.standardMeal;

    return Scaffold(
      appBar: AppBar(title: Text(m.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              m.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Category: ${m.category.name}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Servings:', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: '1.0',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v) ?? 1.0;
                      _servings = d.clamp(0.1, 10.0);
                      setState(() => _recalc());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroBadge('Cal', _cal, Colors.orange),
                _buildMacroBadge('P', _prot, Colors.green),
                _buildMacroBadge('C', _carb, Colors.blue),
                _buildMacroBadge('F', _fat, Colors.redAccent),
              ],
            ),
            const Spacer(),
            SwitchListTile.adaptive(
              title: const Text('Save to Your Meals'),
              value: _saveToFavorites,
              onChanged: (v) => setState(() => _saveToFavorites = v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Add to Today'),
                onPressed: _onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBadge(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value.toString(), style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
