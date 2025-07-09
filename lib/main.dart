import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/meal.dart';
import 'services/theme_model.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register all adapters
  Hive
    ..registerAdapter(MealCategoryAdapter())
    ..registerAdapter(MealAdapter());

  // Open ALL boxes before runApp
  await Future.wait([
    Hive.openBox<Meal>('meals'),
    Hive.openBox<Meal>('saved_meals'),
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: const FitTrackerApp(),
    ),
  );
}

class FitTrackerApp extends StatelessWidget {
  const FitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitTracker',
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
