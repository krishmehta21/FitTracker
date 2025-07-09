import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int todayCalories;
  final int maxCalories;

  const CustomAppBar({
    Key? key,
    required this.todayCalories,
    required this.maxCalories,
  }) : super(key: key);

  // Set preferredSize and toolbarHeight for precise control
  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.tealAccent.shade100;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 6,
      backgroundColor: Colors.black87,
      toolbarHeight: 80, // explicitly set toolbar height
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 28, color: accentColor),
            const SizedBox(width: 10),
            // Title and subtitle in a column, expanded
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FitTracker',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Colors.tealAccent.shade100,
                            Colors.indigoAccent.shade400,
                          ],
                        ).createShader(const Rect.fromLTWH(0, 0, 150, 50)),
                    ),
                  ),
                  Text(
                    'Track your nutrition & health',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Calories + Settings button grouped
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Today',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$todayCalories / $maxCalories kcal',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.settings, color: Colors.white70, size: 24),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings clicked')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
