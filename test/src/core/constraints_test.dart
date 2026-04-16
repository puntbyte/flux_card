import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/constraints.dart';

void main() {
  group('FluxCardConstraints', () {
    // -------------------------------------------------------------------------
    // resolvedWidth
    // -------------------------------------------------------------------------

    group('resolvedWidth', () {
      test('returns explicitWidth when set', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 500),
          explicitWidth: 200,
        );
        expect(c.resolvedWidth, 200.0);
      });

      test('explicitWidth takes priority over fullWidth', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 500),
          explicitWidth: 150,
          fullWidth: true,
        );
        expect(c.resolvedWidth, 150.0);
      });

      test('returns parent maxWidth when fullWidth is true and bounded', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 400),
          fullWidth: true,
        );
        expect(c.resolvedWidth, 400.0);
      });

      test('returns null when fullWidth is true but parent is unbounded', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(), fullWidth: true);
        expect(c.resolvedWidth, isNull);
      });

      test('returns null when no explicit width and fullWidth is false', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(maxWidth: 300));
        expect(c.resolvedWidth, isNull);
      });
    });

    // -------------------------------------------------------------------------
    // resolvedHeight
    // -------------------------------------------------------------------------

    group('resolvedHeight', () {
      test('returns explicitHeight when set', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxHeight: 600),
          explicitHeight: 250,
        );
        expect(c.resolvedHeight, 250.0);
      });

      test('explicitHeight takes priority over fullHeight', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxHeight: 600),
          explicitHeight: 100,
          fullHeight: true,
        );
        expect(c.resolvedHeight, 100.0);
      });

      test('returns parent maxHeight when fullHeight is true and bounded', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxHeight: 800),
          fullHeight: true,
        );
        expect(c.resolvedHeight, 800.0);
      });

      test('returns null when fullHeight is true but parent is unbounded', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(), fullHeight: true);
        expect(c.resolvedHeight, isNull);
      });

      test('returns null when no explicit height and fullHeight is false', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(maxHeight: 500));
        expect(c.resolvedHeight, isNull);
      });
    });

    // -------------------------------------------------------------------------
    // availableWidth
    // -------------------------------------------------------------------------

    group('availableWidth', () {
      test('returns resolvedWidth when explicitly set', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 500),
          explicitWidth: 200,
        );
        expect(c.availableWidth, 200.0);
      });

      test('returns parent maxWidth when parent is bounded', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(maxWidth: 375));
        expect(c.availableWidth, 375.0);
      });

      test('returns infinity when parent is unbounded and no explicit width', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints());
        expect(c.availableWidth, double.infinity);
      });

      test('returns fullWidth value when fullWidth set with bounded parent', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 320),
          fullWidth: true,
        );
        expect(c.availableWidth, 320.0);
      });
    });

    group('hasBoundedAvailableWidth', () {
      test('is true when explicitWidth is set', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(), explicitWidth: 300);
        expect(c.hasBoundedAvailableWidth, isTrue);
      });

      test('is true when parent width is bounded', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints(maxWidth: 375));
        expect(c.hasBoundedAvailableWidth, isTrue);
      });

      test('is true when fullWidth is set with a bounded parent', () {
        const c = FluxCardConstraints(
          parentConstraints: BoxConstraints(maxWidth: 400),
          fullWidth: true,
        );
        expect(c.hasBoundedAvailableWidth, isTrue);
      });

      test('is false when parent width is unbounded and no explicit width exists', () {
        const c = FluxCardConstraints(parentConstraints: BoxConstraints());
        expect(c.hasBoundedAvailableWidth, isFalse);
      });
    });
  });
}
