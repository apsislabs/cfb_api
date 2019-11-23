# frozen_string_literal: true

require 'byebug'
require 'json'
require 'faraday'
require 'strings-case'
require 'cfb_api/version'
require 'cfb_api/errors'
require 'cfb_api/middleware'
require 'cfb_api/models'

module CFB
  REGULAR_SEASON = 'regular'
  POST_SEASON = 'postseason'

  class Client
    def initialize
      @conn = Faraday.new(url: 'https://api.collegefootballdata.com', headers: { 'Content-Type': 'application/json' })
    end

    def conferences
      resp = @conn.get('conferences')
      json_body = parse_response(resp)

      map_to_class(json_body, CFB::Conference)
    end

    def teams(conference: nil)
      resp = @conn.get('teams', conference: conference)
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Team)
    end

    def fbs_teams(year: nil)
      year ||= Time.now.year
      resp = @conn.get('teams/fbs', year: year)
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Team)
    end

    def matchup(team1, team2, min_year: nil, max_year: nil)
      params = {
        team1: team1,
        team2: team2,
        min_year: min_year,
        max_year: max_year
      }

      resp = @conn.get('teams/matchup', prepare_params(params))
      json_body = parse_response(resp)
      CFB::MatchupHistory.new(json_body)
    end

    def roster(team)
      resp = @conn.get('roster', team: team)
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Player)
    end

    def games(year: nil, season_type: CFB::REGULAR_SEASON, week: nil, team: nil, home: nil,
              away: nil, conference: nil)

      year ||= Time.now.year
      params = { year: year, season_type: season_type, week: week, team: team, home: home, away: away, conference: conference }
      resp = @conn.get('games', prepare_params(params))
      json_body = parse_response(resp)

      map_to_class(json_body, CFB::Game)
    end

    def game(game_id)
      resp = @conn.get('games', id: game_id)
      json_body = parse_response(resp)
      CFB::Game.new(json_body[0])
    end

    def play_by_play(year: nil, season_type: CFB::REGULAR_SEASON, week: nil, team: nil, offense: nil,
                     defense: nil, conference: nil, offense_conference: nil,
                     defense_conference: nil, play_type: nil)

      year ||= Time.now.year

      params = {
        year: year,
        season_type: season_type,
        week: week,
        team: team,
        offense: offense,
        defense: defense,
        conference: conference,
        offense_conference: offense_conference,
        defense_conference: defense_conference,
        play_type: play_type
      }

      resp = @conn.get('plays', prepare_params(params))
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Play)
    end

    def drives(year: nil, season_type: CFB::REGULAR_SEASON, week: nil, team: nil, offense: nil, defense: nil, conference: nil, offense_conference: nil, defense_conference: nil)
      year ||= Time.now.year

      params = {
        year: year,
        season_type: season_type,
        week: week,
        team: team,
        offense: offense,
        defense: defense,
        conference: conference,
        offense_conference: offense_conference,
        defense_conference: defense_conference
      }

      resp = @conn.get('drives', prepare_params(params))
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Drive)
    end

    def player_search(search, position: nil, team: nil)
      params = { search_term: search, position: position, team: team }
      resp = @conn.get('player/search', prepare_params(params))
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Player)
    end

    def venues
      resp = @conn.get('venues')
      json_body = parse_response(resp)
      map_to_class(json_body, CFB::Venue)
    end

    def parse_response(resp)
      parsed_resp = JSON.parse(resp.body, symbolize_names: true)

      if parsed_resp.is_a? Hash
        prepare_hash(parsed_resp)
      elsif parsed_resp.is_a? Array
        parsed_resp.map { |hsh| prepare_hash(hsh) }
      end
    end

    private

    def prepare_hash(hsh)
      return hsh unless hsh.is_a? Hash

      hsh.each_with_object({}) do |(k, v), memo|
        v = prepare_hash(v) if v.is_a? Hash
        v = v.map { |vv| prepare_hash(vv) } if v.is_a? Array

        memo[underscore(k)] = v
      end
    end

    def prepare_params(params)
      params = params.each_with_object({}) do |(k, v), memo|
        memo[camelize(k)] = v
      end

      params.reject { |k, v| v.nil? }
    end

    def camelize(str)
      Strings::Case.camelcase(str.to_s)
    end

    def underscore(str)
      Strings::Case.underscore(str.to_s)
    end

    def map_to_class(data, klass)
      data.map { |d| klass.new(d) }
    end
  end
end
