// lib/screens/select_or_add_meal_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal.dart';
import '../models/standard_meal.dart';
import 'standard_meals_page.dart';

class SelectOrAddMealScreen extends StatefulWidget {
  const SelectOrAddMealScreen({super.key});

  @override
  State<SelectOrAddMealScreen> createState() => _SelectOrAddMealScreenState();
}

class _SelectOrAddMealScreenState extends State<SelectOrAddMealScreen> {
  final Box<Meal> _savedMealsBox = Hive.box<Meal>('saved_meals');
  late Future<List<StandardMeal>> _standardMealsFuture;
  List<StandardMeal> _allStandard = [];
  bool _showAddForm = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatsCtrl = TextEditingController();
  MealCategory _selectedCategory = MealCategory.Breakfast;

  // Theme colors from home screen palette:
  final Color baseColor = const Color(0xFF2A1B17);
  final Color cardColor = const Color(0xFF4A342E);
  final Color accentColor = const Color(0xFFD86C2F);
  final Color textPrimary = const Color(0xFFEDE3DB);
  final Color textSecondary = const Color(0xFFBFAF9F);

  @override
  void initState() {
    super.initState();
    _standardMealsFuture = _loadStandardMeals();
  }

  Future<List<StandardMeal>> _loadStandardMeals() async {
    final jsonStr = await rootBundle.loadString('assets/meal.json');
    final data = json.decode(jsonStr) as List;
    _allStandard = data.map((e) => StandardMeal.fromJson(e)).toList();
    return _allStandard;
  }

  void _returnMeal(Meal meal, bool save) {
    final todayMeal = Meal(
      id: DateTime.now().toString(),
      name: meal.name,
      calories: meal.calories,
      protein: meal.protein,
      carbs: meal.carbs,
      fats: meal.fats,
      dateTime: DateTime.now(),
      category: meal.category,
    );
    Navigator.of(context).pop({'meal': todayMeal, 'save': save});
  }

  Future<void> _addCustomMeal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final meal = Meal(
      id: DateTime.now().toString(),
      name: _nameCtrl.text.trim(),
      calories: int.tryParse(_calCtrl.text) ?? 0,
      protein: int.tryParse(_proteinCtrl.text) ?? 0,
      carbs: int.tryParse(_carbsCtrl.text) ?? 0,
      fats: int.tryParse(_fatsCtrl.text) ?? 0,
      dateTime: DateTime.now(),
      category: _selectedCategory,
    );

    await _savedMealsBox.add(meal);
    setState(() => _isLoading = false);
    _returnMeal(meal, true);
  }

  void _openStandardMealsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StandardMealsPage(allMeals: _allStandard),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType? kt,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: kt,
      validator: validator,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: accentColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cardColor.withOpacity(0.6), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cursorColor: accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(null);
        return true;
      },
      child: Scaffold(
        backgroundColor: baseColor,
        appBar: AppBar(
          title: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: cardColor,
          foregroundColor: textPrimary,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => _showAddForm = !_showAddForm),
          backgroundColor: accentColor,
          foregroundColor: baseColor,
          icon: Icon(_showAddForm ? Icons.close : Icons.add_circle),
          label: Text(_showAddForm ? 'Cancel' : 'Create Custom'),
        ),
        body: FutureBuilder<List<StandardMeal>>(
          future: _standardMealsFuture,
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: accentColor,
                  strokeWidth: 3,
                ),
              );
            }

            final savedMeals = _savedMealsBox.values.toList().reversed.toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardColor.withOpacity(0.9), cardColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu, color: accentColor, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Quick Meal Selection',
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose from your saved meals or create a new one',
                        style: TextStyle(color: textSecondary.withOpacity(0.9), fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Custom Add Form
                if (_showAddForm) ...[
                  Card(
                    color: cardColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.create, color: accentColor),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Create Custom Meal',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor),
                              ),
                            ]),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<MealCategory>(
                              value: _selectedCategory,
                              dropdownColor: cardColor,
                              style: TextStyle(color: textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Meal Category',
                                labelStyle: TextStyle(color: textSecondary),
                                prefixIcon: Icon(Icons.category, color: accentColor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: cardColor,
                              ),
                              items: MealCategory.values
                                  .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.name, style: TextStyle(color: textPrimary))))
                                  .toList(),
                              onChanged: (c) => setState(() => _selectedCategory = c!),
                            ),
                            const SizedBox(height: 16),
                            _buildField(_nameCtrl, 'Meal Name', Icons.restaurant_menu,
                                validator: (v) => v!.isEmpty ? 'Enter meal name' : null),
                            const SizedBox(height: 16),
                            _buildField(_calCtrl, 'Calories', Icons.local_fire_department,
                                kt: TextInputType.number,
                                validator: (v) => int.tryParse(v!) == null ? 'Valid calories required' : null),
                            const SizedBox(height: 16),
                            Row(children: [
                              Expanded(
                                child: _buildField(_proteinCtrl, 'Protein (g)', Icons.fitness_center,
                                    kt: TextInputType.number),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildField(_carbsCtrl, 'Carbs (g)', Icons.grain,
                                    kt: TextInputType.number),
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildField(_fatsCtrl, 'Fats (g)', Icons.water_drop,
                                kt: TextInputType.number),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: baseColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 3,
                                ),
                                onPressed: _isLoading ? null : _addCustomMeal,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_circle),
                                          SizedBox(width: 8),
                                          Text('Add to Today\'s Meals',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Saved Meals Section
                if (savedMeals.isNotEmpty) ...[
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.bookmark, color: accentColor),
                    ),
                    const SizedBox(width: 12),
                    Text('Your Saved Meals',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accentColor)),
                  ]),
                  const SizedBox(height: 8),
                  Text('Tap any meal to add it to today\'s log',
                      style: TextStyle(color: textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: savedMeals.length,
                      itemBuilder: (context, index) {
                        final meal = savedMeals[index];
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 12),
                          child: Card(
                            color: cardColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _returnMeal(meal, false),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        child: Text(meal.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: textPrimary),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Icon(Icons.add_circle,
                                          color: accentColor, size: 24),
                                    ]),
                                    const SizedBox(height: 8),
                                    Text('${meal.calories} kcal',
                                        style: TextStyle(
                                            color: accentColor.withOpacity(0.8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        'P:${meal.protein}g • C:${meal.carbs}g • F:${meal.fats}g',
                                        style: TextStyle(
                                            color: textSecondary, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Standard Meals CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardColor.withOpacity(0.6), width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: accentColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(color: accentColor, shape: BoxShape.circle),
                      child: const Icon(Icons.restaurant, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text('Explore Our Standard Meals',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accentColor)),
                    const SizedBox(height: 8),
                    Text(
                        'Discover hundreds of pre-calculated meals from popular restaurants and common foods. Perfect for quick logging!',
                        style: TextStyle(color: textSecondary, fontSize: 14, height: 1.4),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: baseColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: _openStandardMealsPage,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.explore),
                            SizedBox(width: 8),
                            Text('Browse Standard Meals',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 100),
              ],
            );
          },
        ),
      ),
    );
  }
}
