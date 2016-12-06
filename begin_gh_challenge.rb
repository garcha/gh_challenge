#!/usr/bin/ruby
require_relative 'gh_challenge'

gh = GithubChallenge.new(ARGV)
raise gh.validate_date if gh.validate_date
results = gh.execute
puts "-----------Results-------------"
results.each do |k,v|
  puts "#{k} - #{v} events"
end
