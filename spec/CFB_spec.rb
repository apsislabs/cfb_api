# frozen_string_literal: true

RSpec.describe CFB do
  subject(:cfb) { CFB::Client.new }

  it 'has a version number' do
    expect(CFB::VERSION).not_to be nil
  end

  describe '#conferences', :vcr do
    it 'returns an array of CFB::Conference objects' do
      expect(cfb.conferences).to all(be_a CFB::Conference)
    end
  end

  describe '#teams', :vcr do
    it 'returns an array of CFB::Team objects' do
      expect(cfb.teams).to all(be_a CFB::Team)
    end

    it 'respects the conference flag' do
      aac_teams = cfb.teams(conference: 'AAC')
      expect(aac_teams).to all(be_a CFB::Team)
      expect(aac_teams).to all(have_attributes(conference: 'American Athletic'))
      expect(aac_teams.count).to eq 12
    end
  end

  describe '#fbs_teams', :vcr do
    it 'returns an array of CFB::Team objects' do
      expect(cfb.fbs_teams).to all(be_a CFB::Team)
    end

    it 'returns only FBS teams' do
      expect(cfb.fbs_teams.count).to eq 130
    end

    it 'respects the year' do
      expect(cfb.fbs_teams(year: 2016).count).to eq 128
    end
  end

  describe '#matchup', :vcr do
    it 'returns a CFB::MatchupHistory object' do
      expect(cfb.matchup('Oregon', 'Washington')).to be_a CFB::MatchupHistory
    end

    it 'returns an array of CFB::Game objects' do
      expect(cfb.matchup('Oregon', 'Washington').games).to all (be_a CFB::Game)
    end

    it 'respects min_year' do
      expect(cfb.matchup('Oregon', 'Washington', min_year: 2008).games.first.season).to eq 2008
    end

    it 'respects max_year' do
      expect(cfb.matchup('Oregon', 'Washington', max_year: 1994).games.last.season).to eq 1994
    end

    it 'respects min_year and max_year' do
      matchup = cfb.matchup('Oregon', 'Washington', min_year: 1990, max_year: 2000)
      expect(matchup.games.first.season).to eq 1990
      expect(matchup.games.last.season).to eq 2000
    end

    it 'correctly sets game start_date' do
      matchup = cfb.matchup('Oregon', 'Washington')
      expect(matchup.games.first.start_date).to be_a Date
    end
  end

  describe '#roster', :vcr do
    it 'returns an array of CFB::Player objects' do
      expect(cfb.roster('Oregon')).to all(be_a CFB::Player)
    end
  end

  describe '#games', :vcr do
    it 'returns an array of CFB::Game objects' do
      expect(cfb.games).to all(be_a CFB::Game)
    end

    it 'respects year' do
      expect(cfb.games(year: 1896)).to all(have_attributes(season: 1896))
    end

    it 'respects season_type' do
      post_season_games = cfb.games(year: 2018, season_type: CFB::POST_SEASON)
      expect(post_season_games).to all(have_attributes(conference_game: false))
      expect(post_season_games.count).to eq 39
    end

    it 'respects week' do
      expect(cfb.games(year: 2018, week: 1)).to all(have_attributes(week: 1))
    end

    it 'respects team' do
      expect(cfb.games(year: 2018, team: 'Oregon')).to all(have_attributes(home_team: 'Oregon').or(have_attributes(away_team: 'Oregon')))
    end

    it 'respects home' do
      expect(cfb.games(year: 2018, home: 'Oregon')).to all(have_attributes(home_team: 'Oregon'))
    end

    it 'respects away' do
      expect(cfb.games(year: 2018, away: 'Oregon')).to all(have_attributes(away_team: 'Oregon'))
    end

    it 'respects conference' do
      expect(cfb.games(year: 2018, conference: 'SEC')).to all(have_attributes(home_conference: 'SEC').or(have_attributes(away_conference: 'SEC')))
    end
  end

  describe '#game', :vcr do
    it 'returns a single CFB::Game object' do
      game = cfb.game(1)
      expect(game).to be_a CFB::Game
      expect(game.id).to eq 1
    end
  end

  describe '#play_by_play', :vcr do
    it 'returns an array of CFB::Play objects' do
      expect(cfb.play_by_play(week: 1, conference: 'SEC')).to all(be_a CFB::Play)
    end

    it 'respects team' do
      expect(cfb.play_by_play(week: 1, team: 'Oregon')).to all(
        have_attributes(offense: 'Oregon').or(have_attributes(defense: 'Oregon'))
      )
    end

    it 'respects offense' do
      expect(cfb.play_by_play(week: 1, offense: 'Oregon')).to all(
        have_attributes(offense: 'Oregon')
      )
    end

    it 'respects defense' do
      expect(cfb.play_by_play(week: 1, defense: 'Oregon')).to all(
        have_attributes(defense: 'Oregon')
      )
    end

    it 'respects conference' do
      expect(cfb.play_by_play(week: 1, conference: 'SEC')).to all(
        have_attributes(offense_conference: 'SEC').or(have_attributes(defense_conference: 'SEC'))
      )
    end

    it 'respects offense_conference' do
      expect(cfb.play_by_play(week: 1, offense_conference: 'SEC')).to all(
        have_attributes(offense_conference: 'SEC')
      )
    end

    it 'respects defense_conference' do
      expect(cfb.play_by_play(week: 1, defense_conference: 'SEC')).to all(
        have_attributes(defense_conference: 'SEC')
      )
    end
  end

  describe '#drives', :vcr do
    it 'returns an array of CFB::Drive objects' do
      expect(cfb.drives).to all(be_a(CFB::Drive))
    end

    it 'respects team' do
      expect(cfb.drives(week: 1, team: 'Oregon')).to all(
        have_attributes(offense: 'Oregon').or(have_attributes(defense: 'Oregon'))
      )
    end

    it 'respects offense' do
      expect(cfb.drives(week: 1, offense: 'Oregon')).to all(
        have_attributes(offense: 'Oregon')
      )
    end

    it 'respects defense' do
      expect(cfb.drives(week: 1, defense: 'Oregon')).to all(
        have_attributes(defense: 'Oregon')
      )
    end

    it 'respects conference' do
      expect(cfb.drives(week: 1, conference: 'SEC')).to all(
        have_attributes(offense_conference: 'SEC').or(have_attributes(defense_conference: 'SEC'))
      )
    end

    it 'respects offense_conference' do
      expect(cfb.drives(week: 1, offense_conference: 'SEC')).to all(
        have_attributes(offense_conference: 'SEC')
      )
    end

    it 'respects defense_conference' do
      expect(cfb.drives(week: 1, defense_conference: 'SEC')).to all(
        have_attributes(defense_conference: 'SEC')
      )
    end
  end

  describe '#player_search', :vcr do
    it 'returns an array of CFB::Player objects' do
      expect(cfb.player_search('mariota')).to all(be_a CFB::Player)
    end

    it 'returns relevant players' do
      expect(cfb.player_search('mariota')).to all(have_attributes(last_name: 'Mariota'))
    end
  end

  describe '#venues', :vcr do
    it 'returns an array of CFB::Venue objects' do
      expect(cfb.venues).to all(be_a CFB::Venue)
    end
  end
end
