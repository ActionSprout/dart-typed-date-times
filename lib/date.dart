/// A LocalDate represents a full date in the application's configured
/// timezone. This should only be used for display purposes, as
/// dates cannot be effectively communicated without a larger, distributed
/// system without an accompanying timezone. For those purposes, the
/// UtcDateTime type should be used.
class LocalDate {
  /// Creates a new [LocalDate] from its constituent parts: day, month,
  /// weekday, and year.
  const LocalDate({this.day, this.month, this.weekday, this.year});

  /// Creates a new [LocalDate] from an existing [DateTime].
  factory LocalDate.fromDateTime(DateTime datetime) {
    final local = datetime.toLocal();

    return LocalDate(
      day: local.day,
      month: local.month,
      weekday: local.weekday,
      year: local.year,
    );
  }

  /// Creates a new [LocalDate] by parsing the provided ISO-8601-formatted
  /// [String].
  factory LocalDate.parse(String iso8601) {
    final datetime = DateTime.parse(iso8601);

    return LocalDate(
      day: datetime.day,
      month: datetime.month,
      weekday: datetime.weekday,
      year: datetime.year,
    );
  }

  /// Returns the [LocalDate] for the previous day.
  static LocalDate get yesterday => today - _singleDay;

  /// Returns the [LocalDate] for the current day.
  static LocalDate get today => LocalDate.fromDateTime(DateTime.now());

  /// Returns the [LocalDate] for the next day.
  static LocalDate get tomorrow => today + _singleDay;

  /// The represented day, within [1..31].
  final int day;

  /// The represented month, within [1..12].
  final int month;

  /// The represented weekday, within [1..7].
  final int weekday;

  /// The represented year.
  final int year;

  /// Returns true if the date is the same as the previous date
  /// (i.e. yesterday).
  bool get isYesterday => yesterday == this;

  /// Returns true if the date is the same as the current date (i.e. today).
  bool get isToday => today == this;

  /// Returns true if the date is the same as the next date (i.e. tomorrow).
  bool get isTomorrow => tomorrow == this;

  /// Returns the number of days in between this date and the current date.
  /// This value will be positive if the date is in the past, and negative
  /// if this date is in the future.
  int get daysSince => today.toDateTime().difference(toDateTime()).inDays;

  /// Returns the number of days in between the current date and this date.
  /// This value will be positive if the date is in the future, and negative
  /// if this date is in the past.
  int get daysUntil => toDateTime().difference(today.toDateTime()).inDays;

  /// Returns the Date [duration] distance in the past. This method prioritizes
  /// correctness when dealing with [Durations] with a whole number of days
  /// over correctness with other [Durations].
  LocalDate operator -(Duration duration) => LocalDate.fromDateTime(
        // It seems to be more idiomatic to add Durations here, but this math is
        // _definitely_ wrong if you give this a Duration with hours close to,
        // but not exactly, representable in whole days.
        toDateTime().subtract(duration).add(_dayLengthEpsilon),
      );

  /// Returns the Date [duration] distance in the future. This method
  /// prioritizes correctness when dealing with [Durations] with a whole number
  /// of days over correctness with other [Durations].
  LocalDate operator +(Duration duration) => LocalDate.fromDateTime(
        toDateTime().add(duration).add(_dayLengthEpsilon),
      );

  /// Returns [true] if the given object is a [LocalDate] representing the
  /// same date, [false] otherwise.
  @override
  bool operator ==(dynamic other) {
    if (!(other is LocalDate)) {
      return false;
    }

    return day == other.day && month == other.month && year == other.year;
  }

  /// Returns [true] if the given object is a [LocalDate] respresenting a
  /// date after this date, [false] otherwise.
  bool operator <(dynamic other) {
    if (!(other is LocalDate)) {
      return false;
    }

    return toDateTime().millisecondsSinceEpoch <
        other.toDateTime().millisecondsSinceEpoch;
  }

  /// Returns [true] if the given object is a [LocalDate] representing
  /// either the same date or a date after this one, [false] otherwise.
  bool operator <=(dynamic other) {
    return this < other || this == other;
  }

  /// Returns [true] if the given object is a [LocalDate] respresenting a
  /// date before this date, [false] otherwise.
  bool operator >(dynamic other) {
    return !(this <= other);
  }

  /// Returns [true] if the given object is a [LocalDate] representing
  /// either the same date or a date before this one, [false] otherwise.
  bool operator >=(dynamic other) {
    return !(this < other);
  }

  /// Returns a value unique to this date as long as the year is
  /// within [0..2^23].
  @override
  int get hashCode => (year << 9) | (month << 5) | day;

  /// Returns the semantically closest [DateTime]: one with the same day,
  /// month, and year, with the remaining values zeroed out.
  DateTime toDateTime() => DateTime(year, month, day);

  /// Returns an ISO-8601-formatted representation of this date.
  @override
  String toString({bool abbreviated, bool relative}) {
    return toDateTime().toIso8601String().split('T').first;
  }

  /// A convenient constant for the length of a single day.
  static const _singleDay = Duration(days: 1);

  /// This is an epsilon value for the length of a day, as "approximated" by
  /// Dart's DateTime behaviour. That is, this is the largest possible margin
  /// of error when considering the length of a day. It is used especially for
  /// Date "math", e.g. adding or subtracting "days" to/from Dates.
  static const _dayLengthEpsilon = Duration(hours: 1, minutes: 1);
}
