// Tests for the ThinkingOrbs package.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sunnyli_thinking_orbs/thinking_orbs.dart';

void main() {
  testWidgets('ThinkingOrb renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThinkingOrb(state: OrbState.working, size: OrbSize.large),
        ),
      ),
    );

    // Widget should render without errors
    expect(find.byType(ThinkingOrb), findsOneWidget);
  });

  testWidgets('All six OrbStates render correctly', (WidgetTester tester) async {
    final states = OrbState.values;

    for (final state in states) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThinkingOrb(state: state, size: OrbSize.large),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Each state should render without errors
      expect(find.byType(ThinkingOrb), findsOneWidget);
    }
  });

  testWidgets('Both OrbSizes render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ThinkingOrb(state: OrbState.working, size: OrbSize.large),
              ThinkingOrb(state: OrbState.working, size: OrbSize.small),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ThinkingOrb), findsNWidgets(2));
  });

  test('Preset resolves for every state × size combination', () {
    for (final state in OrbState.values) {
      for (final size in OrbSize.values) {
        final preset = resolvePreset(state, size);
        expect(preset.mode, isNotEmpty);
        expect(preset.speed, greaterThan(0));
        expect(preset.opts, isNotEmpty);
      }
    }
  });

  test('Every mode key has a draw function', () {
    for (final mode in stateToMode.values) {
      expect(modeDraws, contains(mode));
      expect(modeDraws[mode], isNotNull);
    }
  });
}
