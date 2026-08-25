require "minitest/autorun"
require "date"
require "kurdish_date"

class KurdishDateTest < Minitest::Test
  K = KurdishDate::KurdishDate

  def setup
    # Make sure each test starts with the default script = :latin.
    K.script = :latin
  end

  # --- Gregorian -> Kurdish Madhi -----------------------------------------

  def test_nowruz_1403_sh_to_1_xakelewe_2724_km
    d = K.from_gregorian(Date.new(2024, 3, 20))
    assert_equal [2724, 1, 1], [d.year, d.month, d.day]
    assert_equal "Xakelêwe", d.month_name
  end

  def test_20_mar_2024_to_1_xakelewe_2724
    assert_equal "2724-01-01", K.from_gregorian(Date.new(2024, 3, 20)).to_s
  end

  def test_21_mar_2024_to_2_xakelewe_2724
    assert_equal "2724-01-02", K.from_gregorian(Date.new(2024, 3, 21)).to_s
  end

  def test_21_mar_2023_to_1_xakelewe_2723
    assert_equal "2723-01-01", K.from_gregorian(Date.new(2023, 3, 21)).to_s
  end

  def test_20_mar_2020_to_1_xakelewe_2720
    # 1399 SH is a leap year, so 20 Mar 2020 = 1 Farwardin 1399 = 2720 KM
    assert_equal "2720-01-01", K.from_gregorian(Date.new(2020, 3, 20)).to_s
  end

  def test_1_jan_2000_to_11_befranbar_2699
    d = K.from_gregorian(Date.new(2000, 1, 1))
    assert_equal "2699-10-11", d.to_s
    assert_equal "Befranbar", d.month_name
  end

  def test_madhi_offset_is_plus_1321
    assert_equal 2726, K.from_gregorian(Date.new(2026, 8, 25)).year
    assert_equal 2724, K.from_gregorian(Date.new(2024, 3, 20)).year
  end

  def test_accepts_datetime_and_time
    assert_equal "2724-01-01",
                 K.from_gregorian(DateTime.new(2024, 3, 20, 12, 0, 0)).to_s
  end

  # --- Kurdish -> Gregorian -----------------------------------------------

  def test_round_trip
    [Date.new(2026, 8, 25), Date.new(2024, 3, 20), Date.new(2000, 1, 1),
     Date.new(1990, 6, 15), Date.new(1950, 11, 1)].each do |g|
      assert_equal g, K.from_gregorian(g).to_gregorian
    end
  end

  def test_1_xakelewe_2724_to_20_mar_2024
    assert_equal Date.new(2024, 3, 20), K.from_kurdish(2724, 1, 1).to_gregorian
  end

  def test_1_xakelewe_2723_to_21_mar_2023
    assert_equal Date.new(2023, 3, 21), K.from_kurdish(2723, 1, 1).to_gregorian
  end

  def test_11_befranbar_2699_to_1_jan_2000
    assert_equal Date.new(2000, 1, 1), K.from_kurdish(2699, 10, 11).to_gregorian
  end

  # --- Weekday names ------------------------------------------------------

  def test_saturday_is_semme_latin
    # 2024-03-23 is a Saturday
    assert_equal "Şemme", K.from_gregorian(Date.new(2024, 3, 23)).weekday_name
  end

  def test_saturday_is_semme_sorani
    assert_equal "شەممە",
                 K.from_gregorian(Date.new(2024, 3, 23)).weekday_name(:sorani)
  end

  def test_friday_is_heyni_latin
    assert_equal "Heynî", K.from_gregorian(Date.new(2024, 3, 22)).weekday_name
  end

  def test_friday_is_heyni_sorani
    assert_equal "هەینی",
                 K.from_gregorian(Date.new(2024, 3, 22)).weekday_name(:sorani)
  end

  def test_sunday_is_yeksemme
    assert_equal "Yekşemme",
                 K.from_gregorian(Date.new(2024, 3, 24)).weekday_name
  end

  def test_monday_is_dusemme
    assert_equal "Duşemme",
                 K.from_gregorian(Date.new(2024, 3, 25)).weekday_name
  end

  def test_tuesday_is_seysemme
    assert_equal "Seyşemme",
                 K.from_gregorian(Date.new(2024, 3, 26)).weekday_name
  end

  def test_wednesday_is_cwarsemme
    assert_equal "Çwarşemme",
                 K.from_gregorian(Date.new(2024, 3, 27)).weekday_name
  end

  def test_thursday_is_pencsemme
    assert_equal "Pêncşemme",
                 K.from_gregorian(Date.new(2024, 3, 28)).weekday_name
  end

  # --- Month names --------------------------------------------------------

  def test_month_name_xakelewe_sorani
    d = K.from_kurdish(2724, 1, 1)
    assert_equal "خاکەلێوە", d.month_name(:sorani)
  end

  def test_month_name_gulan_sorani
    d = K.from_kurdish(2724, 2, 1)
    assert_equal "گوڵان", d.month_name(:sorani)
  end

  def test_month_name_cozerdan_sorani
    assert_equal "جۆزەردان", K.from_kurdish(2724, 3, 1).month_name(:sorani)
  end

  def test_month_name_pusper_sorani
    assert_equal "پووشپەڕ", K.from_kurdish(2724, 4, 1).month_name(:sorani)
  end

  def test_month_name_gelawêj_sorani
    assert_equal "گەلاوێژ", K.from_kurdish(2724, 5, 1).month_name(:sorani)
  end

  def test_month_name_xermanan_sorani
    assert_equal "خەرمانان", K.from_kurdish(2724, 6, 1).month_name(:sorani)
  end

  def test_month_name_rezber_sorani
    assert_equal "ڕەزبەر", K.from_kurdish(2724, 7, 1).month_name(:sorani)
  end

  def test_month_name_xezelwer_sorani
    assert_equal "خەزەڵوەر", K.from_kurdish(2724, 8, 1).month_name(:sorani)
  end

  def test_month_name_sermawez_sorani
    assert_equal "سەرماوەز", K.from_kurdish(2724, 9, 1).month_name(:sorani)
  end

  def test_month_name_befranbar_sorani
    assert_equal "بەفرانبار", K.from_kurdish(2724, 10, 1).month_name(:sorani)
  end

  def test_month_name_rebendan_sorani
    assert_equal "ڕێبەندان", K.from_kurdish(2724, 11, 1).month_name(:sorani)
  end

  def test_month_name_reseme_sorani
    assert_equal "ڕەشەمێ", K.from_kurdish(2724, 12, 1).month_name(:sorani)
  end

  # --- strftime -----------------------------------------------------------

  def setup_strftime
    @d = K.from_kurdish(2724, 3, 9)
  end

  def test_strftime_year
    setup_strftime
    assert_equal "2724", @d.strftime("%Y")
  end

  def test_strftime_two_digit_year
    setup_strftime
    assert_equal "24", @d.strftime("%y")
  end

  def test_strftime_month_padded
    setup_strftime
    assert_equal "03", @d.strftime("%m")
  end

  def test_strftime_month_unpadded
    setup_strftime
    assert_equal "3", @d.strftime("%-m")
  end

  def test_strftime_day_padded
    setup_strftime
    assert_equal "09", @d.strftime("%d")
  end

  def test_strftime_day_unpadded
    setup_strftime
    assert_equal "9", @d.strftime("%-d")
  end

  def test_strftime_kurdish_month_name_latin
    setup_strftime
    assert_equal "Cozerdan", @d.strftime("%B")
  end

  def test_strftime_kurdish_month_name_sorani
    setup_strftime
    assert_equal "جۆزەردان", @d.strftime("%BB")
  end

  def test_strftime_kurdish_weekday_name_latin
    setup_strftime
    d = K.from_gregorian(Date.new(2024, 3, 20))
    assert_equal "Çwarşemme", d.strftime("%A")
  end

  def test_strftime_kurdish_weekday_name_sorani
    setup_strftime
    d = K.from_gregorian(Date.new(2024, 3, 20))
    assert_equal "چوارشەممە", d.strftime("%AA")
  end

  def test_strftime_combined
    setup_strftime
    assert_equal "2724-03-09", @d.strftime("%Y-%m-%d")
  end

  def test_strftime_combined_with_sorani_month
    setup_strftime
    assert_equal "9 جۆزەردان 2724", @d.strftime("%-d %BB %Y")
  end

  # --- Calendar predicates ------------------------------------------------

  def test_leap_year_1403_is_leap
    assert_equal true, K.leap?(1403)
  end

  def test_leap_year_1400_is_not
    assert_equal false, K.leap?(1400)
  end

  def test_month_days_first_six
    (1..6).each { |m| assert_equal 31, K.month_days(1403, m) }
  end

  def test_month_days_seven_to_eleven
    (7..11).each { |m| assert_equal 30, K.month_days(1403, m) }
  end

  def test_month_days_last_in_leap_year
    assert_equal 30, K.month_days(1403, 12)
  end

  def test_month_days_last_in_common_year
    assert_equal 29, K.month_days(1400, 12)
  end

  # --- Validation ---------------------------------------------------------

  def test_rejects_month_below_1
    assert_raises(KurdishDate::InvalidDateError) { K.new(2724, 0, 1) }
  end

  def test_rejects_month_above_12
    assert_raises(KurdishDate::InvalidDateError) { K.new(2724, 13, 1) }
  end

  def test_rejects_day_below_1
    assert_raises(KurdishDate::InvalidDateError) { K.new(2724, 1, 0) }
  end

  def test_rejects_day_above_month_days
    assert_raises(KurdishDate::InvalidDateError) { K.new(2721, 12, 30) }
  end

  def test_accepts_esfand_30_in_leap_year
    assert_silent { K.new(2724, 12, 30) }
  end

  # --- Equality & hashing -------------------------------------------------

  def test_equal_same_ymd
    a = K.new(2724, 1, 1)
    b = K.from_kurdish(2724, 1, 1)
    assert_equal a, b
    assert_equal a.hash, b.hash
  end

  def test_not_equal_different_day
    refute_equal K.new(2724, 1, 1), K.new(2724, 1, 2)
  end

  # --- Locale data --------------------------------------------------------

  def test_locale_latin_months
    months = KurdishDate::Locale::MONTHS[:latin]
    assert_equal 12, months.size
    assert_equal "Xakelêwe", months.first
    assert_equal "Reşemê", months.last
  end

  def test_locale_sorani_months
    months = KurdishDate::Locale::MONTHS[:sorani]
    assert_equal 12, months.size
    assert_equal "خاکەلێوە", months.first
    assert_equal "ڕەشەمێ", months.last
  end

  def test_locale_latin_weekdays
    w = KurdishDate::Locale::WEEKDAYS[:latin]
    assert_equal 7, w.size
    assert_equal "Şemme", w.first
    assert_equal "Heynî", w.last
  end

  def test_locale_sorani_weekdays
    w = KurdishDate::Locale::WEEKDAYS[:sorani]
    assert_equal 7, w.size
    assert_equal "شەممە", w.first
    assert_equal "هەینی", w.last
  end

  # --- Global script switch ----------------------------------------------

  def test_global_script_switches_default
    K.script = :sorani
    d = K.from_gregorian(Date.new(2024, 3, 20))
    assert_equal "چوارشەممە", d.weekday_name
    assert_equal "خاکەلێوە", d.month_name
    K.script = :latin
  end
end
