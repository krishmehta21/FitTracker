// lib/screens/standard_meals_page.dart

import 'package:flutter/material.dart';
import '../models/standard_meal.dart';
import 'meal_detail_page.dart';
import '../models/meal.dart';

class StandardMealsPage extends StatefulWidget {
  final List<StandardMeal> allMeals;
  const StandardMealsPage({required this.allMeals, super.key});

  @override
  State<StandardMealsPage> createState() => _StandardMealsPageState();
}

class _StandardMealsPageState extends State<StandardMealsPage> {
  late List<StandardMeal> _displayMeals;
  bool _sortAsc = true;
  int _sortColumn = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _displayMeals = List.from(widget.allMeals)
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  void _sort<T>(int col, Comparable<T> Function(StandardMeal m) fn) {
    setState(() {
      if (_sortColumn == col) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = col;
        _sortAsc = true;
      }
      _displayMeals.sort((a, b) {
        final cmp = Comparable.compare(fn(a), fn(b));
        return _sortAsc ? cmp : -cmp;
      });
    });
  }

  void _filter(String q) {
    setState(() {
      _searchQuery = q.toLowerCase();
      _displayMeals = widget.allMeals.where((m) {
        return m.name.toLowerCase().contains(_searchQuery)
            || m.category.name.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  Widget _headerCell(String label, int colIndex) {
    return InkWell(
      onTap: () {
        switch (colIndex) {
          case 0:
            _sort<String>(0, (m) => m.name);
            break;
          case 1:
            _sort<num>(1, (m) => m.calories);
            break;
          case 2:
            _sort<num>(2, (m) => m.protein);
            break;
          case 3:
            _sort<num>(3, (m) => m.carbs);
            break;
          case 4:
            _sort<num>(4, (m) => m.fats);
            break;
          case 5:
            _sort<String>(5, (m) => m.category.name);
            break;
        }
      },
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (_sortColumn == colIndex)
            Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Standard Meals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search meals…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: _filter,
            ),
          ),
          Container(
            color: theme.primaryColorLight,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 120, child: _headerCell('Name', 0)),
                  SizedBox(width: 60, child: _headerCell('Cal', 1)),
                  SizedBox(width: 60, child: _headerCell('Prot', 2)),
                  SizedBox(width: 60, child: _headerCell('Carb', 3)),
                  SizedBox(width: 60, child: _headerCell('Fats', 4)),
                  SizedBox(width: 100, child: _headerCell('Category', 5)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _displayMeals.length,
              itemBuilder: (ctx, i) {
                final m = _displayMeals[i];
                final bg = i.isOdd
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.surface;
                return Card(
                  color: bg,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailPage(standardMeal: m),
                        ),
                      );
                      if (result != null && result['meal'] != null) {
                        final Meal meal = result['meal'] as Meal;
                        final bool save = result['save'] as bool;
                        Navigator.of(context).pop({'meal': meal, 'save': save});
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 120, child: Text(m.name)),
                            SizedBox(width: 60, child: Text('${m.calories}')),
                            SizedBox(width: 60, child: Text('${m.protein}g')),
                            SizedBox(width: 60, child: Text('${m.carbs}g')),
                            SizedBox(width: 60, child: Text('${m.fats}g')),
                            SizedBox(
                              width: 100,
                              child: Text(m.category.name, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Tap a meal to view details and add',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
