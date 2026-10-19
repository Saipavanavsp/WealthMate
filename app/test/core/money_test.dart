import 'package:flutter_test/flutter_test.dart';
import 'package:wealthmate/core/money/money.dart';

void main() {
  group('Money', () {
    test('parses user input into paise', () {
      expect(Money.tryParse('1,250.5'), const Money(125050));
      expect(Money.tryParse('99'), const Money(9900));
      expect(Money.tryParse('0.05'), const Money(5));
      expect(Money.tryParse('12.345'), isNull);
      expect(Money.tryParse('-5'), isNull);
      expect(Money.tryParse('abc'), isNull);
      expect(Money.tryParse(''), isNull);
    });

    test('adds and subtracts without floating point drift', () {
      var total = const Money.zero();
      for (var i = 0; i < 1000; i++) {
        total += const Money(10); // ten paise, a thousand times
      }
      expect(total, const Money(10000));
      expect(const Money(500) - const Money(800), const Money(-300));
    });

    test('refuses to mix currencies', () {
      expect(() => const Money(1) + const Money(1, currency: 'USD'), throwsArgumentError);
    });

    test('split keeps every paisa', () {
      final parts = const Money(10000).split(3);
      expect(parts.map((m) => m.minor), [3334, 3333, 3333]);
      expect(parts.fold<int>(0, (s, m) => s + m.minor), 10000);
    });

    test('allocate splits by weight using largest remainder', () {
      final parts = const Money(1000).allocate([2, 1, 1]);
      expect(parts.map((m) => m.minor), [500, 250, 250]);

      final uneven = const Money(100).allocate([1, 1, 1]);
      expect(uneven.fold<int>(0, (s, m) => s + m.minor), 100);
    });

    test('allocate rejects bad weights', () {
      expect(() => const Money(100).allocate([]), throwsArgumentError);
      expect(() => const Money(100).allocate([0, 0]), throwsArgumentError);
      expect(() => const Money(100).split(0), throwsArgumentError);
    });

    test('formats as decimal and currency', () {
      expect(const Money(125050).toDecimalString(), '1250.50');
      expect(const Money(-5).toDecimalString(), '-0.05');
      expect(const Money(12345600).format(), '₹1,23,456.00');
    });

    test('compares and supports equality', () {
      expect(const Money(5) < const Money(6), isTrue);
      expect(const Money(5) >= const Money(5), isTrue);
      expect(const Money(5), const Money(5));
      expect(const Money(5).hashCode, const Money(5).hashCode);
      expect(const Money(-5).abs(), const Money(5));
      expect(const Money(1000) * 1.5, const Money(1500));
    });
  });
}
