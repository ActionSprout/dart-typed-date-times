# Typed Dates and DateTimes for Dart

This library provides a set of abstractions around the native `DateTime` to allow compile-time checking of the timezone (local vs. UTC) of a point in time, and a separate time for dates without a useful time.

## Why?

While building ActionSprout's mobile app, we wanted additional guarantees around what was being passed from the UI layer to our API client, and vice-versa.
