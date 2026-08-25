require_relative "lib/kurdish_date/version"

Gem::Specification.new do |spec|
  spec.name          = "kurdish_date"
  spec.version       = KurdishDate::VERSION
  spec.authors       = ["RojCode"]
  spec.email         = ["rojcode@example.com"]

  spec.summary       = "Kurdish (Sorani) calendar — convert Gregorian dates to/from Kurdish dates."
  spec.description   = "A Ruby library for working with the Kurdish (Sorani) calendar. " \
                       "Provides conversion to/from the Gregorian calendar, Kurdish month and " \
                       "weekday names, and formatting helpers for Central Kurdish (Sorani)."
  spec.homepage      = "https://github.com/rojcode/kurdish_date"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/rojcode/kurdish_date",
    "changelog_uri"     => "https://github.com/rojcode/kurdish_date/blob/main/CHANGELOG.md",
    "bug_tracker_uri"   => "https://github.com/rojcode/kurdish_date/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.glob([
    "lib/**/*.rb",
    "lib/**/*.yml",
    "README.md",
    "LICENSE",
    "CHANGELOG.md"
  ])
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
end
