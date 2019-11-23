# frozen_string_literal: true

require 'virtus'

module CFB
  class Model
    include Virtus.model
  end

  class ApiModel < Model
    private

    def connection
      @connection ||= CFB::Client.new
    end
  end

  class LatLng < Model
    attribute :x, Float
    attribute :y, Float
  end

  class ClockTime < Model
    attribute :minutes, Integer
    attribute :seconds, Integer
  end

  class Conference < ApiModel
    attribute :id, Integer
    attribute :name, String
    attribute :short_name, String
    attribute :abbreviation, String

    def to_s
      short_nam
    end
  end

  class Team < ApiModel
    attribute :id, Integer
    attribute :school, String
    attribute :mascot, String
    attribute :abbreviation, String
    attribute :alt_name_1, String
    attribute :alt_name_2, String
    attribute :alt_name_3, String
    attribute :conference, String
    attribute :division, String
    attribute :color, String
    attribute :alt_color, String
    attribute :logos, Array[String]

    def to_s
      school
    end
  end

  class Game < ApiModel
    attribute :id, Integer
    attribute :season, Integer
    attribute :week, Integer
    attribute :season_type, String
    attribute :start_date, Date
    attribute :neutral_site, Boolean
    attribute :conference_game, Boolean
    attribute :attendance, Integer
    attribute :venue_id, Integer
    attribute :venue, String
    attribute :home_team, String
    attribute :home_conference, String
    attribute :home_points, Integer
    attribute :home_line_scores, Array[Integer]
    attribute :away_team, String
    attribute :away_conference, String
    attribute :away_points, Integer
    attribute :away_line_scores, Array[Integer]

    def start_date=(val)
      val = Date.strptime(val) if val.is_a? String
      super(val)
    end

    def to_s
      "#{away_team} @ #{home_team} (Week #{week}, #{season})"
    end

    alias :date= :start_date=
    alias :home_score= :home_points=
    alias :away_score= :away_points=
  end

  class MatchupHistory < ApiModel
    attribute :team1, String
    attribute :team2, String
    attribute :start_year, Integer
    attribute :end_year, Integer
    attribute :team1_wins, Integer
    attribute :team2_wins, Integer
    attribute :ties, Integer
    attribute :games, Array[Game]
  end

  class Player < ApiModel
    attribute :id, Integer
    attribute :first_name, String
    attribute :last_name, String
    attribute :height, Integer
    attribute :weight, Integer
    attribute :jersey, Integer
    attribute :year, Integer
    attribute :position, String
    attribute :city, String
    attribute :state, String
    attribute :country, String
  end

  class Venue < ApiModel
    attribute :id, Integer
    attribute :name, String
    attribute :capacity, Integer
    attribute :grass, Boolean
    attribute :city, String
    attribute :state, String
    attribute :zip, String
    attribute :country_code, String
    attribute :location, LatLng
    attribute :elevation, Integer
    attribute :year, Integer
    attribute :dome, Boolean
  end

  class Drive < ApiModel
    attribute :offense, String
    attribute :offense_conference, String
    attribute :defense, String
    attribute :defense_conference, String
    attribute :id, Integer
    attribute :game_id, Integer
    attribute :scoring, Boolean
    attribute :start_period, Integer
    attribute :start_yardline, Integer
    attribute :start_time, ClockTime
    attribute :end_period, Integer
    attribute :end_yardline, Integer
    attribute :end_time, ClockTime
    attribute :plays, Integer
    attribute :yards, Integer
    attribute :drive_result, String

    def game
      @game ||= connection.game(game_id)
    end
  end

  class Play < ApiModel
    attribute :id, Integer
    attribute :drive_id, Integer
    attribute :offense, String
    attribute :offense_conference, String
    attribute :offense_score, Integer
    attribute :defense, String
    attribute :home, String
    attribute :away, String
    attribute :defense_conference, String
    attribute :defense_points, Integer
    attribute :period, Integer
    attribute :clock, ClockTime
    attribute :yard_line, Integer
    attribute :down, Integer
    attribute :distance, Integer
    attribute :yards_gained, Integer
    attribute :play_type, String
    attribute :play_text, String
  end
end
