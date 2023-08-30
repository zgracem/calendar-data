#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "pathname"

# Refines `Date` with {#next_wday} and {#prev_wday} methods.
module RelativeDate
  refine Date do
    # @param dayname [String] a weekday name from `Date::DAYNAMES`
    # @return [Date] the next `dayname` from `self`
    def next_wday(dayname = "Sunday")
      relative_wday(dayname, :next)
    end

    # @param dayname [String] a weekday name from `Date::DAYNAMES`
    # @return [Date] the previous `dayname` from `self`
    def prev_wday(dayname = "Sunday")
      relative_wday(dayname, :prev)
    end

    private

    # @param dayname [String] a weekday name from `Date::DAYNAMES`
    # @param direction [Symbol] `:next` or `:prev`
    # @return [Date] the `direction` `dayname` from `self`
    def relative_wday(dayname, direction)
      raise ArgumentError, "bad dayname: #{dayname.inspect}" unless Date::DAYNAMES.include?(dayname)
      raise ArgumentError, "bad direction: #{direction.inspect}" unless %i[next prev].include?(direction)

      target_wday = Date::DAYNAMES.index(dayname)
      7.times do |n|
        test_day = send("#{direction}_day", n + 1)
        return test_day if test_day.wday == target_wday
      end
    end
  end

  using self

  # @param wday_name [String] a weekday name from `Date::DAYNAMES`
  # @param adverb [Symbol] `:before` or `:after`
  # @param date_string [String] a string to be parsed by `Date.parse`
  # @return [Date] the `adverb` `wday_name` from `date_string`
  def self.parse(wday_name, adverb, date_string)
    raise ArgumentError, "bad dayname: #{wday_name.inspect}" unless Date::DAYNAMES.include?(wday_name)
    raise ArgumentError, "bad adverb: #{adverb.inspect}" unless %i[before after].include?(adverb)

    date = Date.parse(date_string.to_s)
    case adverb
    when :before
      date.prev_wday(wday_name)
    when :after
      date.next_wday(wday_name)
    end
  end
end

# Produces a BSD calendar file (see {.write}) with movable feast days from the
# [General Roman Calendar](https://en.wikipedia.org/wiki/General_Roman_Calendar).
module CatholicCal
  using RelativeDate

  # @return [Hash{Symbol=>String}] movable feast days and their names
  MOVABLE_FEASTS = {
    baptism_of_the_lord: "Baptism of the Lord",
    trinity_sunday:      "Trinity Sunday",
    corpus_christi:      "Corpus Christi",
    christ_the_king:     "Feast of Christ the King",
    holy_family:         "Feast of the Holy Family"
  }

  # @return [String]
  CALENDAR_NAME = "catholic_more"

  # @return [Pathname]
  CALENDAR_FILE = Pathname("#{Dir.home}/Developer/share/calendar/src/calendar.catholicmore")

  # @return [String]
  TEMPLATE = <<~CAL.freeze
    /*
     * Roman Catholic holy days with variable dates, %<years>s
     * Maintained by ZGM
     * vim:ft=calendar
     */

    #ifndef _calendar_#{CALENDAR_NAME}_
    #define _calendar_#{CALENDAR_NAME}_

    LANG=utf-8

    %<dates>s

    #endif /* !_calendar_#{CALENDAR_NAME}_ */
  CAL

  class << self
    # @param year [Integer]
    # @return [Date] the date of Easter in `year`
    def easter(year = Date.today.year)
      require "open3"
      stdout_str, stderr_str, status = Open3.capture3("ncal -e #{year}")

      return Date.parse(stdout_str.strip) if status.success?

      raise stderr_str.strip
    end

    # @param year [Integer]
    # @return [Date] the date of Pentecost in `year`
    def pentecost(year = Date.today.year)
      easter(year) + 49
    end

    # @param year [Integer]
    # @return [Date] the date of the Feast of the Baptism of the Lord in `year`
    def baptism_of_the_lord(year = Date.today.year)
      RelativeDate.parse("Sunday", :after, Date.new(year, 1, 6))
    end

    # @param year [Integer]
    # @return [Date] the date of Trinity Sunday in `year`
    def trinity_sunday(year = Date.today.year)
      RelativeDate.parse("Sunday", :after, pentecost(year))
    end

    def corpus_christi(year = Date.today.year)
      RelativeDate.parse("Thursday", :after, trinity_sunday(year))
    end

    # @param year [Integer]
    # @return [Date] the date of Christmas in `year`
    def christmas(year = Date.today.year)
      Date.new(year, 12, 25)
    end

    # @param year [Integer]
    # @return [Date] the last Sunday of Advent in `year`
    def last_advent_sunday(year = Date.today.year)
      RelativeDate.parse("Sunday", :before, christmas(year))
    end

    # @param year [Integer]
    # @return [Date] the date of the Feast of Christ the King in `year`
    def christ_the_king(year = Date.today.year)
      last_advent_sunday(year) - 28
    end

    # @param year [Integer]
    # @return [Date] the date of the feast of the Holy Family in `year`
    def holy_family(year = Date.today.year)
      rdate = RelativeDate.parse("Sunday", :after, christmas(year))
      rdate.strftime.match?(/01-01$/) ? Date.new(year, 12, 30) : rdate
    end

    # @param years [Array<Integer>] years for which to generate calendar entries
    # @return [String] calendar entries for `years`
    def for_years(*years)
      years.map do |year|
        MOVABLE_FEASTS.map do |mthd, name|
          [send(mthd, year).strftime("%Y/%m/%d"), name].join("\t")
        end
      end
    end

    # @param years [Array<Integer>] years for which to generate a calendar file
    # @return [String] a calendar file for `years`
    def to_calendar(*years)
      format(TEMPLATE,
             years: [years.first, years.last].uniq.join("-"),
             dates: for_years(*years).join("\n"))
    end

    def write(*years)
      CALENDAR_FILE.write(to_calendar(*years))
    end
  end
end

def main(start_year, end_year)
  years = Range.new(start_year, end_year).to_a
  CatholicCal.write(*years)
end

# puts CatholicCal.to_calendar(*(2023..2029).to_a) # debug
main(*ARGV)
