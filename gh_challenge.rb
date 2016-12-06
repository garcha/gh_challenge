require 'open-uri'
require 'zlib'
require 'yajl'
require 'optparse'
require 'date'
require 'pry'

class GithubChallenge

  def initialize(options)
    options = OptionParser.new do |opt|
      #opt.banner = "Usage: begin_gh_challenge.rb [--after DATETIME] [--before DATETIME] [--event EVENT_NAME] [-n COUNT]"
       opt.on("--after","--after DATETIME","the date after") { |after| @after = after }
       opt.on("--before","--before DATETIME","the date before") { |before| @before = before }
       opt.on("--event","--event EVENT_NAME","the event name") { |event| @event = event }
       opt.on("--count","--n COUNT","the count") { |count| @count = count.to_i }
    end.parse!
  end

  def validate_date
    def error_message(type)
      "\n Missing #{type} value, please use the following format:
     begin_gh_challenge.rb --after 2016-11-01T13:00:00Z --before 2016-11-02T03:12:14-03:00 --event PushEvent --count 42"
    end

    return error_message("after") if @after.nil?
    return error_message("before") if @before.nil?
    return error_message("event") if @event.nil?
    return error_message("count") if @count.nil?
  end

  def execute
    start_date = DateTime.parse(@after)
    end_date = DateTime.parse(@before)

    repo_and_count = Hash.new(0)

    (start_date..end_date).each do |date|
      check_date =  date.strftime("%Y-%m-%d-%H")

      gz = open("http://data.githubarchive.org/#{check_date}.json.gz")
      js = Zlib::GzipReader.new(gz).read

      Yajl::Parser.parse(js) do |event|
        if event['type'] == @event
          if !(event['repo'] == nil)
            repo = event['repo']['url'].sub('https://api.github.com/repos/', "")
          else
            repo = event['repository']['url'].sub('https://github.com/', "")
          end
          repo_and_count[repo] += 1
        end
      end
    end

    sorted_repo_count = repo_and_count.sort_by{ |x, y| -y}
    return sorted_repo_count.first(@count)
  end
end
