# CFB API Client [![Build Status](https://travis-ci.org/apsislabs/cfb_api.svg?branch=master)](https://travis-ci.org/apsislabs/cfb_api)

A Ruby client for the `collegefootballapi`. API Specs can be found [here](https://api.collegefootballdata.com/api/docs/?url=/api-docs.json#/).

This gem also provides a small library of models for interacting with the returned data, and normalizes some of the responses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cfb_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install CFB

## Usage

Initialize a client like so:

```ruby
require 'cfb_api'
cfb = CFB::Client.new
```

Once you have a client, you can issue requests to the following endpoints:

### Conferences

Returns an array of `CFB::Conference` objects.

```ruby
cfb.conferences
```

### Teams

Returns an array of `CFB::Team` objects.

```ruby
teams = cfb.teams
sec_teams = cfb.teams(conference: 'SEC')
```

### FBS Teams

Returns an array of FBS teams as `CFB::Team` objects.

```ruby
cfb.fbs_teams
cfb.fbs_teams(year: 2012)
```

### Matchup

Returns a history of a matchup between any two teams as a `CFB::MatchupHistory` object.

```ruby
cfb.matchup('Oregon', 'Washington')
cfb.matchup('Oklahoma', 'Texas', min_year: 1960, max_year: 1969)
```

### Roster

Returns a team's roster as an array of `CFB::Player` objects.

```ruby
cfb.roster('Oregon')
```

### Games

Returns an array of `CFB::Game` objects.

```ruby
cfb.games
cfb.games(year: 2004, week: 10)
cfb.games(season_type: CFB::POST_SEASON, team: 'Oregon')
cfb.games(season_type: CFB::REGULAR_SEASON, conference: 'AAC')
```

### Game

Returns a single `CFB::Game` object.

```ruby
cfb.game(1)
```

### Play-by-Play

Returns an array of `CFB::Play` objects.

**Note:** This returns a ton of data, and is recommended that you apply several filters to reduce the size of your response.

```ruby
cfb.play_by_play(year: 2016, week: 1, team: 'Oregon')
```

### Drives

Returns an array of `CFB::Drive` objects.

**Note:** This returns a ton of data, and is recommended that you apply several filters to reduce the size of your response.

```ruby
cfb.drives(year: 2011, week: 10, offense: 'Alabama')
```

### Player Search

Returns an array of players matching the search query as `CFB::Player` objects.

**Note:** This endpoint is... unreliable... in its responses. Not every player is available.

```ruby
cfb.player_search('mariota')
```

### Venues

Returns an array of stadium data as `CFB::Venue` objects.

```ruby
cfb.venues
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
