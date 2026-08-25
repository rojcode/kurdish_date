module KurdishDate
  # Locale data for the Kurdish (Sorani) calendar.
  #
  # The Kurdish (Sorani) calendar is the same astronomical calendar as
  # the Solar Hijri (Jalali) calendar used in Iran. This module holds
  # the localised month and weekday names in Central Kurdish.
  #
  # Two scripts are provided for each entry:
  #
  # * `:latin`  — the standard transliteration (Hawar-style) used in
  #   everyday Latin-script Kurdish writing.
  # * `:sorani` — the native Sorani script (Arabic-based), which is the
  #   standard orthography in Iraqi Kurdistan and the Iranian Kurdish
  #   regions for daily, literary, and official use.
  module Locale
    # Kurdish month names. The first six months have 31 days, the next
    # five have 30 days, and the 12th month has 29 (or 30 in a leap year).
    MONTHS = {
      latin: [
        "Xakelêwe",   # 1
        "Gulan",      # 2
        "Cozerdan",   # 3
        "Pûşper",     # 4
        "Gelawêj",    # 5
        "Xermanan",   # 6
        "Rezber",     # 7
        "Xezelwer",   # 8
        "Sermawez",   # 9
        "Befranbar",  # 10
        "Rêbendan",   # 11
        "Reşemê"      # 12
      ].freeze,
      sorani: [
        "خاکەلێوە",   # 1
        "گوڵان",      # 2
        "جۆزەردان",   # 3
        "پووشپەڕ",    # 4
        "گەلاوێژ",    # 5
        "خەرمانان",   # 6
        "ڕەزبەر",     # 7
        "خەزەڵوەر",   # 8
        "سەرماوەز",   # 9
        "بەفرانبار",  # 10
        "ڕێبەندان",   # 11
        "ڕەشەمێ"      # 12
      ].freeze
    }.freeze

    # Weekday names. The Kurdish week starts on Saturday.
    WEEKDAYS = {
      latin: [
        "Şemme",     # 0 — Saturday — شەممە
        "Yekşemme",  # 1 — Sunday — یەکشەممە
        "Duşemme",   # 2 — Monday — دووشەممە
        "Seyşemme",  # 3 — Tuesday — سێشەممە
        "Çwarşemme", # 4 — Wednesday — چوارشەممە
        "Pêncşemme", # 5 — Thursday — پێنجشەممە
        "Heynî"      # 6 — Friday — هەینی
      ].freeze,
      sorani: [
        "شەممە",     # 0 — Saturday
        "یەکشەممە",  # 1 — Sunday
        "دووشەممە",   # 2 — Monday
        "سێشەممە",   # 3 — Tuesday
        "چوارشەممە",  # 4 — Wednesday
        "پێنجشەممە",  # 5 — Thursday
        "هەینی"      # 6 — Friday
      ].freeze
    }.freeze

    # Default script when none is specified.
    DEFAULT_SCRIPT = :latin

    # Returns the month name for the given 1-based month number, in the
    # requested script (:latin or :sorani).
    def self.month_name(month, script = DEFAULT_SCRIPT)
      MONTHS.fetch(script)[month - 1]
    end

    # Returns the weekday name for the given 0-based weekday index
    # (Saturday = 0), in the requested script (:latin or :sorani).
    def self.weekday_name(weekday_index, script = DEFAULT_SCRIPT)
      WEEKDAYS.fetch(script)[weekday_index]
    end
  end
end
