require "date"
require "kurdish_date"

RSpec.describe KurdishDate::KurdishDate do
  before { described_class.script = :latin }

  describe ".from_gregorian" do
    it "converts Nowruz 1403 SH to 1 Xakelêwe 2724 KM" do
      d = described_class.from_gregorian(Date.new(2024, 3, 20))
      expect([d.year, d.month, d.day]).to eq([2724, 1, 1])
      expect(d.month_name).to eq("Xakelêwe")
    end

    it "converts 20 Mar 2024 to 1 Xakelêwe 2724" do
      d = described_class.from_gregorian(Date.new(2024, 3, 20))
      expect(d.to_s).to eq("2724-01-01")
    end

    it "applies the +1321 Madhi offset on top of the Solar Hijri year" do
      expect(described_class.from_gregorian(Date.new(2026, 8, 25)).year).to eq(2726)
      expect(described_class.from_gregorian(Date.new(2024, 3, 20)).year).to eq(2724)
    end

    it "accepts DateTime and Time" do
      d = described_class.from_gregorian(DateTime.new(2024, 3, 20, 12, 0, 0))
      expect(d.to_s).to eq("2724-01-01")
    end
  end

  describe "#to_gregorian" do
    it "round-trips with from_gregorian" do
      [Date.new(2026, 8, 25), Date.new(2024, 3, 20), Date.new(2000, 1, 1),
       Date.new(1990, 6, 15), Date.new(1950, 11, 1)].each do |g|
        expect(described_class.from_gregorian(g).to_gregorian).to eq(g)
      end
    end

    it "converts 1 Xakelêwe 2724 to 20 Mar 2024" do
      expect(described_class.from_kurdish(2724, 1, 1).to_gregorian).to eq(Date.new(2024, 3, 20))
    end
  end

  describe "weekday names" do
    {
      Date.new(2024, 3, 23) => "Şemme",       # Saturday
      Date.new(2024, 3, 24) => "Yekşemme",    # Sunday
      Date.new(2024, 3, 25) => "Duşemme",     # Monday
      Date.new(2024, 3, 26) => "Seyşemme",    # Tuesday
      Date.new(2024, 3, 27) => "Çwarşemme",   # Wednesday
      Date.new(2024, 3, 28) => "Pêncşemme",   # Thursday
      Date.new(2024, 3, 22) => "Heynî"        # Friday
    }.each do |g, expected_latin|
      it "returns Latin weekday name for #{g}" do
        expect(described_class.from_gregorian(g).weekday_name).to eq(expected_latin)
      end
    end
  end

  describe "month names" do
    {
      1 => "Xakelêwe", 2 => "Gulan",   3 => "Cozerdan",
      4 => "Pûşper",   5 => "Gelawêj", 6 => "Xermanan",
      7 => "Rezber",   8 => "Xezelwer", 9 => "Sermawêz",
      10 => "Befranbar", 11 => "Rêbendan", 12 => "Reşemê"
    }.each do |m, latin_name|
      it "Latin name for month #{m} is #{latin_name}" do
        expect(described_class.from_kurdish(2724, m, 1).month_name).to eq(latin_name)
      end
    end

    {
      1 => "خاکەلێوە", 2 => "گوڵان", 3 => "جۆزەردان",
      4 => "پووشپەڕ", 5 => "گەلاوێژ", 6 => "خەرمانان",
      7 => "ڕەزبەر", 8 => "خەزەڵوەر", 9 => "سەرماوەز",
      10 => "بەفرانبار", 11 => "ڕێبەندان", 12 => "ڕەشەمێ"
    }.each do |m, sorani_name|
      it "Sorani name for month #{m} is #{sorani_name}" do
        expect(described_class.from_kurdish(2724, m, 1).month_name(:sorani)).to eq(sorani_name)
      end
    end
  end

  describe "global script" do
    it "is :latin by default" do
      expect(described_class.script).to eq(:latin)
    end

    it "switches the default weekday_name" do
      described_class.script = :sorani
      d = described_class.from_gregorian(Date.new(2024, 3, 20))
      expect(d.weekday_name).to eq("چوارشەممە")
    end

    it "switches the default month_name" do
      described_class.script = :sorani
      d = described_class.from_kurdish(2724, 1, 1)
      expect(d.month_name).to eq("خاکەلێوە")
    end
  end

  describe "#strftime" do
    let(:d) { described_class.from_kurdish(2724, 3, 9) }

    it "%Y → 4-digit year" do
      expect(d.strftime("%Y")).to eq("2724")
    end

    it "%m → zero-padded month" do
      expect(d.strftime("%m")).to eq("03")
    end

    it "%-d → unpadded day" do
      expect(d.strftime("%-d")).to eq("9")
    end

    it "%B → Latin month name" do
      expect(d.strftime("%B")).to eq("Cozerdan")
    end

    it "%BB → Sorani month name (regardless of default script)" do
      described_class.script = :sorani
      expect(d.strftime("%BB")).to eq("جۆزەردان")
    end

    it "%A → Latin weekday name" do
      d = described_class.from_gregorian(Date.new(2024, 3, 20))
      expect(d.strftime("%A")).to eq("Çwarşemme")
    end

    it "%AA → Sorani weekday name (regardless of default script)" do
      d = described_class.from_gregorian(Date.new(2024, 3, 20))
      expect(d.strftime("%AA")).to eq("چوارشەممە")
    end

    it "combines tokens" do
      expect(d.strftime("%Y-%m-%d")).to eq("2724-03-09")
    end
  end

  describe ".leap?" do
    it "marks 1403 SH as a leap year" do
      expect(described_class.leap?(1403)).to be true
    end

    it "marks 1400 SH as common" do
      expect(described_class.leap?(1400)).to be false
    end
  end

  describe ".month_days" do
    it "returns 31 for months 1..6" do
      (1..6).each { |m| expect(described_class.month_days(1403, m)).to eq(31) }
    end

    it "returns 30 for months 7..11" do
      (7..11).each { |m| expect(described_class.month_days(1403, m)).to eq(30) }
    end

    it "returns 30 in a leap year for month 12" do
      expect(described_class.month_days(1403, 12)).to eq(30)
    end

    it "returns 29 in a common year for month 12" do
      expect(described_class.month_days(1400, 12)).to eq(29)
    end
  end

  describe "validation" do
    it "rejects month < 1" do
      expect { described_class.new(2724, 0, 1) }.to raise_error(KurdishDate::InvalidDateError)
    end

    it "rejects month > 12" do
      expect { described_class.new(2724, 13, 1) }.to raise_error(KurdishDate::InvalidDateError)
    end

    it "rejects day < 1" do
      expect { described_class.new(2724, 1, 0) }.to raise_error(KurdishDate::InvalidDateError)
    end

    it "rejects day > month_days" do
      expect { described_class.new(2721, 12, 30) }.to raise_error(KurdishDate::InvalidDateError)
    end
  end

  describe "Locale" do
    it "exposes 12 month names in each script" do
      expect(KurdishDate::Locale::MONTHS[:latin].size).to eq(12)
      expect(KurdishDate::Locale::MONTHS[:sorani].size).to eq(12)
    end

    it "exposes 7 weekday names in each script, starting with Saturday" do
      expect(KurdishDate::Locale::WEEKDAYS[:latin].size).to eq(7)
      expect(KurdishDate::Locale::WEEKDAYS[:sorani].size).to eq(7)
      expect(KurdishDate::Locale::WEEKDAYS[:latin].first).to eq("Şemme")
      expect(KurdishDate::Locale::WEEKDAYS[:sorani].first).to eq("شەممە")
    end

    it "exposes helper methods" do
      expect(KurdishDate::Locale.month_name(5, :sorani)).to eq("گەلاوێژ")
      expect(KurdishDate::Locale.weekday_name(0, :latin)).to eq("Şemme")
    end
  end
end
