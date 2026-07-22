import 'package:flutter/material.dart';

import 'thinking_orbs.dart';

void main() {
  runApp(const ThinkingOrbsDemo());
}

class ThinkingOrbsDemo extends StatefulWidget {
  const ThinkingOrbsDemo({super.key});

  @override
  State<ThinkingOrbsDemo> createState() => _ThinkingOrbsDemoState();
}

class _ThinkingOrbsDemoState extends State<ThinkingOrbsDemo> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _paused = false;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return MaterialApp(
      title: 'Thinking Orbs',
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
      home: _DemoScaffold(
        isDark: isDark,
        themeMode: _themeMode,
        paused: _paused,
        speed: _speed,
        onThemeChanged: (mode) => setState(() => _themeMode = mode),
        onPausedChanged: (v) => setState(() => _paused = v),
        onSpeedChanged: (v) => setState(() => _speed = v),
      ),
    );
  }
}

class _DemoScaffold extends StatelessWidget {
  const _DemoScaffold({
    required this.isDark,
    required this.themeMode,
    required this.paused,
    required this.speed,
    required this.onThemeChanged,
    required this.onPausedChanged,
    required this.onSpeedChanged,
  });

  final bool isDark;
  final ThemeMode themeMode;
  final bool paused;
  final double speed;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<bool> onPausedChanged;
  final ValueChanged<double> onSpeedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allStates = OrbState.values;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Thinking Orbs'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              onThemeChanged(
                themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _ControlsCard(
            paused: paused,
            speed: speed,
            onPausedChanged: onPausedChanged,
            onSpeedChanged: onSpeedChanged,
          ),
          const SizedBox(height: 28),

          // --- Large orbs (64px) ---
          Text(
            'Large · 64px',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // 根据宽度自适应列数：每个卡片最小宽度约 120px
              final crossAxisCount = (constraints.maxWidth / 140).floor().clamp(1, 6);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: allStates.length,
                itemBuilder: (context, index) {
                  return _OrbCard(
                    state: allStates[index],
                    size: OrbSize.large,
                    paused: paused,
                    speed: speed,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 32),

          // --- Small orbs (20px) ---
          Text(
            'Small · 20px',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: allStates.map((state) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: ThinkingOrb(
                          state: state,
                          size: OrbSize.small,
                          paused: paused,
                          speed: speed,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        state.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),

          // --- Inline usage example ---
          _InlineExample(paused: paused, speed: speed),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ControlsCard extends StatelessWidget {
  const _ControlsCard({
    required this.paused,
    required this.speed,
    required this.onPausedChanged,
    required this.onSpeedChanged,
  });

  final bool paused;
  final double speed;
  final ValueChanged<bool> onPausedChanged;
  final ValueChanged<double> onSpeedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  paused ? Icons.play_arrow : Icons.pause,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    paused ? 'Paused' : 'Animating',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                Switch(
                  value: !paused,
                  onChanged: (v) => onPausedChanged(!v),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.speed, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speed: ${speed.toStringAsFixed(1)}×',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Slider(
                        value: speed,
                        min: 0.1,
                        max: 4,
                        divisions: 39,
                        onChanged: onSpeedChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbCard extends StatelessWidget {
  const _OrbCard({
    required this.state,
    required this.size,
    required this.paused,
    required this.speed,
  });

  final OrbState state;
  final OrbSize size;
  final bool paused;
  final double speed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThinkingOrb(
            state: state,
            size: size,
            paused: paused,
            speed: speed,
          ),
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

class _InlineExample extends StatelessWidget {
  const _InlineExample({
    required this.paused,
    required this.speed,
  });

  final bool paused;
  final double speed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E2E)
            : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inline usage',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Agent is '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: ThinkingOrb(
                      state: OrbState.composing,
                      size: OrbSize.small,
                      paused: paused,
                      speed: speed,
                    ),
                  ),
                ),
                const TextSpan(text: ' composing a response'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Searching knowledge base '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: ThinkingOrb(
                      state: OrbState.searching,
                      size: OrbSize.small,
                      paused: paused,
                      speed: speed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
