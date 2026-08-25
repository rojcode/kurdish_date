require "date"
require "kurdish_date/version"
require "kurdish_date/locale"

module KurdishDate
  class Error < StandardError; end
  class InvalidDateError < Error; end

  # Represents a date in the Kurdish (Sorani) calendar.
  #
  # The Kurdish (Sorani) calendar uses the same astronomical year
  # structure as the Solar Hijri (Jalali) calendar used in Iran — the
  # first six months have 31 days, the next five 30 days, and the
  # final month (Esme Xakêle / Reşemê / Esfand) has 29 days in a
  # common year and 30 in a leap year.
  #
  # The year numbering is the **Madhi (Kurdish Median) era**, counting
  # from the traditional founding of the Median kingdom by Diako
  # around 700 BCE. The offset is fixed at +1321 years from the
  # Solar Hijri (Jalali) year, so a Hijri-Shamsi year of 1405
  # corresponds to the Kurdish Madhi year of 2726.
  #
  # The day-by-day conversion uses Borkowski's analytic approximation
  # (the same algorithm used by .NET PersianCalendar, jalaali-js, and
  # the Java PersianDate library), accurate to within one day over a
  # window of roughly 5,000 years.
  #
  # Month and weekday names are available in two scripts:
  #
  # * `:latin`  — Hawar-style Latin transliteration
  # * `:sorani` — the native Arabic-based Sorani script
  #
  # Use {KurdishDate.script=}, {KurdishDate.script}, or the per-call
  # `:script` option on the formatting methods to choose.
  class KurdishDate
    MONTHS = Locale::MONTHS
    WEEKDAYS = Locale::WEEKDAYS

    # Ruby's Date#wday: 0=Sun, 1=Mon, ..., 5=Fri, 6=Sat.
    KURDISH_WEEK_START = 6 # Saturday

    # Borkowski's reference constants. The Solar Hijri epoch (1 Farwardin
    # 1 SH) corresponds to JDN 2,121,446.
    CYCLE_DAYS  = 1_029_983  # days in a 2820-year super-cycle
    CYCLE_YEARS = 2_820
    PERSIAN_EPOCH = 2_121_446
    YEAR_LENGTH  = 365.24219858156028
    LEAP_THRESHOLD = 0.24219858156028

    # Offset from Solar Hijri year to Kurdish Madhi (Diako) year.
    MADHI_OFFSET = 1321

    @script = Locale::DEFAULT_SCRIPT

    class << self
      # Default script (:latin or :sorani) used by formatting helpers
      # when no script is passed explicitly.
      attr_accessor :script
    end

    attr_reader :year, :month, :day

    def initialize(year, month, day)
      unless year.is_a?(Integer) && month.is_a?(Integer) && day.is_a?(Integer)
        raise InvalidDateError, "year, month and day must be Integers"
      end

      unless month.between?(1, 12)
        raise InvalidDateError, "month must be between 1 and 12, got #{month}"
      end

      # Calendar rules (leap year, month lengths) are defined on the
      # Solar Hijri year; the Madhi year differs by a fixed offset.
      solar_year = year - MADHI_OFFSET
      max_day = self.class.month_days(solar_year, month)
      unless day.between?(1, max_day)
        raise InvalidDateError,
              "day must be between 1 and #{max_day} for month #{month} of year #{year}, got #{day}"
      end

      @year = year
      @month = month
      @day = day
    end

    # ---- factory methods ------------------------------------------------

    # Build a KurdishDate from a Gregorian date (Date / DateTime / Time).
    def self.from_gregorian(date)
      jd = date.respond_to?(:jd) ? date.jd : ::Date.parse(date.to_s).jd
      jy, jm, jd2 = jalali_from_jd(jd)
      new(jy + MADHI_OFFSET, jm, jd2)
    end

    # Build a KurdishDate from a Kurdish Madhi (year, month, day).
    def self.from_kurdish(year, month, day)
      new(year, month, day)
    end

    # Today in the Kurdish calendar.
    def self.today
      from_gregorian(::Date.today)
    end

    # Now in the Kurdish calendar.
    def self.now
      from_gregorian(::DateTime.now)
    end

    # ---- accessors ------------------------------------------------------

    def to_gregorian
      jd = self.class.jd_from_jalali(@year - MADHI_OFFSET, @month, @day)
      ::Date.jd(jd)
    end

    def to_date
      to_gregorian
    end

    def to_time
      to_gregorian.to_time
    end

    def to_datetime
      jd = self.class.jd_from_jalali(@year - MADHI_OFFSET, @month, @day)
      ::DateTime.jd(jd)
    end

    # Returns the Kurdish weekday index, 0-based, starting at Saturday.
    def weekday_index
      ((to_gregorian.wday - KURDISH_WEEK_START) % 7)
    end

    # Full Kurdish weekday name, e.g. "Şemme" (Latin) or
    # "شەممە" (Sorani). `script` defaults to the class-level setting.
    def weekday_name(script = nil)
      Locale.weekday_name(weekday_index, script || self.class.script)
    end

    # Full Kurdish month name, e.g. "Gulan" (Latin) or
    # "گوڵان" (Sorani). `script` defaults to the class-level setting.
    def month_name(script = nil)
      Locale.month_name(@month, script || self.class.script)
    end

    def leap?
      self.class.leap?(@year - MADHI_OFFSET)
    end

    def month_days
      self.class.month_days(@year - MADHI_OFFSET, @month)
    end

    # ---- formatting -----------------------------------------------------

    # Format the date. Supported tokens:
    #   %Y  4-digit year                  %y  2-digit year
    #   %m  zero-padded month             %-m unpadded month
    #   %d  zero-padded day               %-d unpadded day
    #   %B  full month name (Latin)       %BB full month name (Sorani)
    #   %b  abbreviated month name (Latin)
    #   %A  full weekday name (Latin)     %AA full weekday name (Sorani)
    #   %a  abbreviated weekday name (Latin) %aa abbreviated weekday name (Sorani)
    #
    # The single-letter tokens (%B / %A / %a / %b) use the default
    # script set by `KurdishDate.script=`. The double-letter tokens
    # (%BB / %AA / %aa) always use Sorani so a mixed-language format
    # string is possible.
    def strftime(format = "%Y-%m-%d", script: nil)
      script = (script || self.class.script).to_sym
      format.gsub(/%-?Y|%-?y|%-?m|%-?d|%BB|%AA|%aa|%B|%b|%A|%a/) do |token|
        case token
        when "%Y"  then @year.to_s.rjust(4, "0")
        when "%y"  then (@year % 100).to_s.rjust(2, "0")
        when "%m"  then @month.to_s.rjust(2, "0")
        when "%-m" then @month.to_s
        when "%d"  then @day.to_s.rjust(2, "0")
        when "%-d" then @day.to_s
        when "%BB" then Locale.month_name(@month, :sorani)
        when "%AA" then Locale.weekday_name(weekday_index, :sorani)
        when "%aa" then Locale.weekday_name(weekday_index, :sorani)[0, 3]
        when "%B"  then Locale.month_name(@month, script)
        when "%b"  then Locale.month_name(@month, script)[0, 3]
        when "%A"  then Locale.weekday_name(weekday_index, script)
        when "%a"  then Locale.weekday_name(weekday_index, script)[0, 3]
        end
      end
    end

    def to_s(format = "%Y-%m-%d", **opts)
      strftime(format, **opts)
    end

    def inspect
      "#<KurdishDate #{strftime("%Y-%m-%d")} (#{weekday_name})>"
    end

    def ==(other)
      other.is_a?(KurdishDate) &&
        year == other.year && month == other.month && day == other.day
    end
    alias eql? ==

    def hash
      [@year, @month, @day].hash
    end

    def to_a
      [@year, @month, @day]
    end
    alias deconstruct to_a

    # ---- calendar predicates -------------------------------------------

    # Note: leap year is a property of the *solar* year, which is shared
    # between the Solar Hijri and Kurdish Madhi calendars.
    def self.leap?(solar_hijri_year)
      ((solar_hijri_year + 2346) * LEAP_THRESHOLD) % 1 < LEAP_THRESHOLD
    end

    def self.month_days(solar_hijri_year, month)
      return 31 if month.between?(1, 6)
      return 30 if month.between?(7, 11)
      leap?(solar_hijri_year) ? 30 : 29
    end

    # ---- internal: JDN <-> Solar-Hijri (Borkowski) ---------------------
    # All internal conversions operate on Solar Hijri year numbers.
    # The Madhi offset is applied at the public API boundary.

    # JDN -> (Solar Hijri year, month, day). Borkowski's approximation.
    def self.jalali_from_jd(jd)
      jd = jd.to_i
      offset = jd - PERSIAN_EPOCH
      cycle_no = offset / CYCLE_DAYS
      cycle_no -= 1 if offset < 0
      cycle_start = PERSIAN_EPOCH + cycle_no * CYCLE_DAYS
      yc = ((jd - cycle_start) / YEAR_LENGTH).floor
      year = yc + 475 + cycle_no * CYCLE_YEARS
      lll = PERSIAN_EPOCH + cycle_no * CYCLE_DAYS + (yc * YEAR_LENGTH).floor
      day = jd - lll + 1
      if day > (leap?(year) ? 366 : 365)
        year += 1
        day = 1
      end
      month = 1
      d = day
      while month <= 12 && d > month_days(year, month)
        d -= month_days(year, month)
        month += 1
      end
      [year, month, d]
    end

    # (Solar Hijri year, month, day) -> JDN. Borkowski's reverse.
    def self.jd_from_jalali(year, month, day)
      era = (year - 475) / CYCLE_YEARS
      era -= 1 if (year - 475) < 0
      y_c = (year - 475) - era * CYCLE_YEARS
      first_d = PERSIAN_EPOCH + era * CYCLE_DAYS + (y_c * YEAR_LENGTH).floor
      first_d + (day_of_year(year, month, day) - 1)
    end

    # Day-of-year in the Solar Hijri / Kurdish calendar.
    def self.day_of_year(year, month, day)
      sum = 0
      (1...month).each { |m| sum += month_days(year, m) }
      sum + day
    end
  end
end
