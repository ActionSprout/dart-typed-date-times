// ignore_for_file: prefer_asserts_with_message

import '../lib/date.dart';
import 'package:test/test.dart';

void main() {
  test('today is today', () {
    assert(LocalDate.today.isToday);
    assert(!LocalDate.today.isTomorrow);
    assert(!LocalDate.today.isYesterday);
  });

  test('tomorrow is tomorrow', () {
    assert(!LocalDate.tomorrow.isToday);
    assert(LocalDate.tomorrow.isTomorrow);
    assert(!LocalDate.tomorrow.isYesterday);
  });

  test('yesterday is yesterday', () {
    assert(!LocalDate.yesterday.isToday);
    assert(!LocalDate.yesterday.isTomorrow);
    assert(LocalDate.yesterday.isYesterday);
  });

  test('LocalDates can be equated', () {
    assert(LocalDate(day: 1, month: 2, year: 3) ==
        LocalDate(day: 1, month: 2, year: 3));
    assert(LocalDate(day: 101, month: 202, year: 303) ==
        LocalDate(day: 101, month: 202, year: 303));
  });

  test('LocalDates can be compared', () {
    assert(LocalDate(day: 1, month: 2, year: 3) <
        LocalDate(day: 2, month: 2, year: 3));
    assert(LocalDate(day: 1, month: 2, year: 3) <
        LocalDate(day: 1, month: 3, year: 3));
    assert(LocalDate(day: 1, month: 2, year: 3) <
        LocalDate(day: 1, month: 2, year: 4));
  });

  test('LocalDates can be added', () {
    assert((LocalDate.yesterday + const Duration(days: 1)).isToday);
    assert((LocalDate.today + const Duration(days: 1)).isTomorrow);
    assert(LocalDate(day: 1, month: 2, year: 3) + const Duration(days: 30) ==
        LocalDate(day: 3, month: 3, year: 3));
  });

  test('LocalDates can be subtracted', () {
    assert((LocalDate.tomorrow - const Duration(days: 1)).isToday);
    assert((LocalDate.today - const Duration(days: 1)).isYesterday);
    assert(LocalDate(day: 3, month: 3, year: 3) - const Duration(days: 30) ==
        LocalDate(day: 1, month: 2, year: 3));
  });

  test('the day after the day before a leap day is the leap day', () {
    expect(
      LocalDate(day: 28, month: 2, year: 2020) + const Duration(days: 1),
      LocalDate(day: 29, month: 2, year: 2020),
    );
  });

  test('the day after a leap day is the 1st of March', () {
    expect(
      LocalDate(day: 29, month: 2, year: 2020) + const Duration(days: 1),
      LocalDate(day: 1, month: 3, year: 2020),
    );
  });

  test('the day before the day after a leap day is the leap day', () {
    expect(
      LocalDate(day: 1, month: 3, year: 2020) - const Duration(days: 1),
      LocalDate(day: 29, month: 2, year: 2020),
    );
  });

  test('the day before a leap day is the 28th of February', () {
    expect(
      LocalDate(day: 29, month: 2, year: 2020) - const Duration(days: 1),
      LocalDate(day: 28, month: 2, year: 2020),
    );
  });

  test('Tomorrow is 1 day until and -1 days since', () {
    expect(LocalDate.tomorrow.daysUntil, 1);
    expect(LocalDate.tomorrow.daysSince, -1);
  });

  test('Yesterday is 1 day since and -1 days until', () {
    expect(LocalDate.yesterday.daysSince, 1);
    expect(LocalDate.yesterday.daysUntil, -1);
  });

  test('Hash codes for dates are unique', () {
    assert(LocalDate.today.hashCode != LocalDate.yesterday.hashCode);
    assert(LocalDate.today.hashCode != LocalDate.tomorrow.hashCode);

    // Ties the test to the implementation, but the implementation is stable
    // enough to not make that problematic.
    expect(LocalDate(day: 1, month: 2, year: 3).hashCode, 1601);
    expect(LocalDate(day: 31, month: 12, year: 3333).hashCode, 1706911);
  });
}
