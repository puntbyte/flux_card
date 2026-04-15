import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

// These tests verify that all documented enum values exist and are distinct.
// They serve as a contract: if a value is removed or renamed, a test breaks,
// giving a clear signal before any API change ships.

void main() {
  group('FluxLayoutMode', () {
    test('contains all four values', () {
      expect(FluxLayoutMode.values, hasLength(4));
      expect(FluxLayoutMode.values, containsAll([
        FluxLayoutMode.column,
        FluxLayoutMode.row,
        FluxLayoutMode.inline,
        FluxLayoutMode.responsive,
      ]));
    });
  });

  group('FluxMediaPosition', () {
    test('contains start and end', () {
      expect(FluxMediaPosition.values, hasLength(2));
      expect(FluxMediaPosition.values, containsAll([
        FluxMediaPosition.start,
        FluxMediaPosition.end,
      ]));
    });
  });

  group('FluxMediaSpan', () {
    test('contains all six values', () {
      expect(FluxMediaSpan.values, hasLength(6));
      expect(FluxMediaSpan.values, containsAll([
        FluxMediaSpan.all,
        FluxMediaSpan.header,
        FluxMediaSpan.body,
        FluxMediaSpan.footer,
        FluxMediaSpan.headerAndBody,
        FluxMediaSpan.bodyAndFooter,
      ]));
    });
  });

  group('FluxTarget', () {
    test('contains all five values including card', () {
      expect(FluxTarget.values, hasLength(5));
      expect(FluxTarget.values, containsAll([
        FluxTarget.card,
        FluxTarget.media,
        FluxTarget.header,
        FluxTarget.body,
        FluxTarget.footer,
      ]));
    });
  });

  group('FluxNotchEdge', () {
    test('contains vertical and horizontal', () {
      expect(FluxNotchEdge.values, hasLength(2));
      expect(FluxNotchEdge.values, containsAll([
        FluxNotchEdge.vertical,
        FluxNotchEdge.horizontal,
      ]));
    });
  });

  group('FluxNotchSide', () {
    test('contains start, end, and both', () {
      expect(FluxNotchSide.values, hasLength(3));
      expect(FluxNotchSide.values, containsAll([
        FluxNotchSide.start,
        FluxNotchSide.end,
        FluxNotchSide.both,
      ]));
    });
  });

  group('FluxSlotBoundary', () {
    test('contains all three boundaries', () {
      expect(FluxSlotBoundary.values, hasLength(3));
      expect(FluxSlotBoundary.values, containsAll([
        FluxSlotBoundary.afterMedia,
        FluxSlotBoundary.afterHeader,
        FluxSlotBoundary.afterBody,
      ]));
    });
  });
}