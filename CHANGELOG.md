# Changelog

All notable changes to `kurdish_date` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.2.0] - 2026-08-25

### Added
- **Two scripts**: `KurdishDate.script` / `KurdishDate.script=` to pick
  the default output script (`:latin` or `:sorani`).
- All month and weekday names available in both Latin (Hawar-style
  transliteration) and Sorani (native Arabic-based) scripts.
- `Locale.month_name(month, script)` and
  `Locale.weekday_name(weekday_index, script)` helpers.
- New `strftime` tokens: `%BB`, `%AA`, `%aa` — always render in
  Sorani, regardless of the default script, so a single format string
  can mix scripts (e.g. `"%A، %-d %BB %Y"`).
- `#weekday_name(script = nil)` and `#month_name(script = nil)` accept
  an explicit script per call.
- `Locale` module reorganised: `MONTHS` and `WEEKDAYS` are now
  hashes keyed by `:latin` / `:sorani`.
- Corrected spellings: `Şemme`, `Yekşemme`, `Duşemme`, `Seyşemme`,
  `Çwarşemme`, `Pêncşemme`, `Heynî`; `Xezelwer`, `Pûşper`.

## [0.1.0] - 2026-08-25

### Added
- Initial release.
- `KurdishDate::KurdishDate.from_gregorian(date)` — convert a Gregorian
  `Date` / `DateTime` / `Time` to a Kurdish Madhi date.
- `KurdishDate::KurdishDate.from_kurdish(year, month, day)` — build a
  Kurdish date directly.
- `KurdishDate::KurdishDate.today` / `.now` — current date in the Kurdish
  calendar.
- `#to_gregorian` / `#to_date` / `#to_time` / `#to_datetime` — convert
  back to a Ruby date / time.
- `#strftime` with Kurdish month / weekday names, supporting
  `%Y`, `%y`, `%m`, `%-m`, `%d`, `%-d`, `%B`, `%A`, `%a`.
- `KurdishDate::Locale::MONTHS` and `KurdishDate::Locale::WEEKDAYS` —
  Central Kurdish (Sorani) month and weekday names.
- Borkowski-based astronomical conversion, accurate to within one day
  over a window of roughly 5,000 years.
- Minitest test suite (39 tests, 61 assertions).

[Unreleased]: https://github.com/rojcode/kurdish_date/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rojcode/kurdish_date/releases/tag/v0.1.0
