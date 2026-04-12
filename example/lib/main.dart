import 'package:flutter/material.dart';

import 'pages/blog_page.dart';
import 'pages/destination_list_page.dart';
import 'pages/product_grid_page.dart';

void main() => runApp(const FluxShowcase());

class FluxShowcase extends StatefulWidget {
  const FluxShowcase({super.key});

  @override
  State<FluxShowcase> createState() => _FluxShowcaseState();
}

class _FluxShowcaseState extends State<FluxShowcase> {
  ThemeMode _mode = ThemeMode.light;

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFF4F46E5),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF818CF8),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flux Card Engine', style: TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              IconButton(
                tooltip: 'Toggle theme',
                icon: Icon(_mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  setState(() {
                    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
            ],
            bottom: const TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Product'),
                Tab(text: 'Travel'),
                Tab(text: 'Blog'),
              ],
            ),
          ),
          body: const TabBarView(children: [ProductGridPage(), DestinationListPage(), BlogPage()]),
        ),
      ),
    );
  }
}
