// A minimal example app for thinking_orbs_flutter.
// Run with: `flutter run` from the example/ directory.

import 'package:flutter/material.dart';
import 'package:thinking_orbs_flutter/thinking_orbs.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thinking Orbs Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thinking Orbs'),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () => setState(() {
                _themeMode = _themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              }),
              tooltip: 'Toggle theme',
            ),
          ],
        ),
        body: const _OrbGrid(),
      ),
    );
  }
}

class _OrbGrid extends StatelessWidget {
  const _OrbGrid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        for (final state in OrbState.values) _OrbCard(state: state, theme: theme),
      ],
    );
  }
}

class _OrbCard extends StatelessWidget {
  const _OrbCard({required this.state, required this.theme});

  final OrbState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThinkingOrb(state: state, size: OrbSize.large),
          const SizedBox(height: 12),
          Text(
            state.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
