# kurdish_date

A Ruby library for working with the **Kurdish (Sorani) calendar**, also
known as the Kurdish Madhi (Median) calendar.

The day-by-day structure is the same as the Solar Hijri (Jalali) calendar
used in Iran — six 31-day months, five 30-day months, and a final 29-day
month (30 in a leap year). The year numbering is the **Madhi era**, which
counts from the traditional founding of the Median kingdom by Diako
around 700 BCE. The offset from the Solar Hijri year is fixed at **+1321**,
so the Hijri-Shamsi year 1405 corresponds to the Kurdish Madhi year 2726.

The conversion algorithm is the [Borkowski approximation][borkowski] —
the same approach used by .NET `PersianCalendar`, the Java
`PersianDate` library, and `jalaali-js`. It is astronomically accurate to
within one day over a window of roughly 5,000 years.

[borkowski]: http://www.astro.uni.torun.pl/~kb/Papers/EMP/PersianC-EMP.htm

## Installation

Add to your `Gemfile`:

```ruby
gem "kurdish_date"
```

Or install directly:

```bash
gem install kurdish_date
```

## Usage

```ruby
require "kurdish_date"
require "date"

# Convert a Gregorian date into the Kurdish (Madhi) calendar.
KurdishDate::KurdishDate.from_gregorian(Date.new(2024, 3, 20))
# => #<KurdishDate 2724-01-01 (Çwarşemme)>

# Convert a Kurdish date back to a Gregorian Date.
KurdishDate::KurdishDate.from_kurdish(2724, 1, 1).to_gregorian
# => #<Date: 2024-03-20 ...>

# Today, in the Kurdish calendar.
KurdishDate::KurdishDate.today
# => #<KurdishDate ...>

# Format with strftime (subset of strftime tokens).
d = KurdishDate::KurdishDate.from_kurdish(2724, 3, 9)
d.strftime("%Y-%m-%d")    # => "2724-03-09"
d.strftime("%-d %B %Y")   # => "9 Cozerdan 2724"   (Latin, the default)
```

### Two scripts: Latin and Sorani

Month and weekday names are available in two scripts:

* **Latin** — Hawar-style transliteration (`Xakelêwe`, `Çwarşemme`).
* **Sorani** — the native Arabic-based Sorani script
  (`خاکەلێوە`, `چوارشەممە`).

Set the default script globally:

```ruby
KurdishDate::KurdishDate.script = :sorani

d = KurdishDate::KurdishDate.from_gregorian(Date.new(2024, 3, 20))
d.month_name          # => "خاکەلێوە"
d.weekday_name        # => "چوارشەممە"
d.strftime("%-d %B %Y")  # => "1 خاکەلێوە 2724"
```

Or pass the script per call:

```ruby
d.month_name(:latin)    # => "Xakelêwe"
d.month_name(:sorani)   # => "خاکەلێوە"
```

Or mix scripts in a single format string using the `BB` / `AA` / `aa`
tokens (always Sorani, regardless of the default):

```ruby
d.strftime("%A، %-d %BB %Y")  # => "چوارشەممە، 1 خاکەلێوە 2724"
```

## API

### Factory methods

| Method | Description |
| --- | --- |
| `KurdishDate.from_gregorian(date)` | Build from a `Date` / `DateTime` / `Time`. |
| `KurdishDate.from_kurdish(year, month, day)` | Build from a Kurdish date. |
| `KurdishDate.today` | Today, in the Kurdish calendar. |
| `KurdishDate.now` | Now, in the Kurdish calendar. |

### Instance methods

| Method | Description |
| --- | --- |
| `#year`, `#month`, `#day` | Kurdish Madhi year / month / day. |
| `#to_gregorian` | Convert back to a `Date`. |
| `#to_date`, `#to_time`, `#to_datetime` | Convenience conversions. |
| `#weekday_name(script = nil)` | Kurdish weekday, e.g. `"Çwarşemme"` or `"چوارشەممە"`. |
| `#month_name(script = nil)` | Kurdish month, e.g. `"Gulan"` or `"گوڵان"`. |
| `#leap?` | True if the underlying Solar Hijri year is a leap year. |
| `#month_days` | Number of days in this month. |
| `#strftime(format, script: nil)` | Format with the tokens listed below. |

### `strftime` tokens

| Token | Meaning | Script |
| --- | --- | --- |
| `%Y` | 4-digit year | — |
| `%y` | 2-digit year | — |
| `%m` | Zero-padded month | — |
| `%-m` | Unpadded month | — |
| `%d` | Zero-padded day | — |
| `%-d` | Unpadded day | — |
| `%B` | Full month name | default script |
| `%BB` | Full month name | **Sorani** (always) |
| `%b` | Abbreviated month name | default script |
| `%A` | Full weekday name | default script |
| `%AA` | Full weekday name | **Sorani** (always) |
| `%a` | Abbreviated weekday name | default script |
| `%aa` | Abbreviated weekday name | **Sorani** (always) |

### Calendar predicates

| Method | Description |
| --- | --- |
| `KurdishDate.leap?(solar_hijri_year)` | Leap-year check (Solar Hijri year, not Madhi). |
| `KurdishDate.month_days(solar_hijri_year, month)` | Days in the given month. |
| `KurdishDate.script` / `KurdishDate.script=` | Default script (`:latin` or `:sorani`). |

### `Locale` module

```ruby
KurdishDate::Locale::MONTHS[:latin]   # 12 Latin month names
KurdishDate::Locale::MONTHS[:sorani]  # 12 Sorani month names
KurdishDate::Locale::WEEKDAYS[:latin]  # 7 Latin weekday names (Sat..Fri)
KurdishDate::Locale::WEEKDAYS[:sorani] # 7 Sorani weekday names
KurdishDate::Locale.month_name(1, :sorani)    # => "خاکەلێوە"
KurdishDate::Locale.weekday_name(0, :latin)   # => "Şemme"
```

## Kurdish month names

| # | Latin | Sorani | Persian equivalent |
| - | - | - | - |
| 1 | Xakelêwe | خاکەلێوە | Farvardin |
| 2 | Gulan | گوڵان | Ordibehesht |
| 3 | Cozerdan | جۆزەردان | Khordad |
| 4 | Pûşper | پووشپەڕ | Tir |
| 5 | Gelawêj | گەلاوێژ | Mordad |
| 6 | Xermanan | خەرمانان | Shahrivar |
| 7 | Rezber | ڕەزبەر | Mehr |
| 8 | Xezelwer | خەزەڵوەر | Aban |
| 9 | Sermawêz | سەرماوەز | Azar |
| 10 | Befranbar | بەفرانبار | Dey |
| 11 | Rêbendan | ڕێبەندان | Bahman |
| 12 | Reşemê | ڕەشەمێ | Esfand |

The Kurdish week starts on **Saturday**.

## Development

```bash
bundle install
rake test
```

The test suite uses Minitest (stdlib). An RSpec suite is also included in
`spec/` for projects that prefer RSpec; install RSpec separately to use it.

## License

MIT — see [LICENSE](LICENSE).
