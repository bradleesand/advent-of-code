#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'fileutils'

# Usage: ./fetch_readmes.rb 2015
# Optional: AOC_SESSION=your_session_cookie ./fetch_readmes.rb 2015 (to also fetch input.txt)

year = ARGV[0] || "2015"
session_cookie = ENV['AOC_SESSION']
should_fetch_input = !session_cookie.nil? && !session_cookie.empty?

if should_fetch_input
  puts "Session cookie found - will fetch both READMEs and input files"
else
  puts "No session cookie - will only fetch READMEs (input files skipped)"
  puts "To also fetch inputs: AOC_SESSION=your_cookie ./fetch_readmes.rb #{year}"
end

def fetch_problem(year, day, session_cookie = nil)
  uri = URI("https://adventofcode.com/#{year}/day/#{day}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.path)
  request['Cookie'] = "session=#{session_cookie}" if session_cookie

  response = http.request(request)

  if response.code != "200"
    puts "Failed to fetch day #{day}: HTTP #{response.code}"
    return nil
  end

  response.body
end

def html_to_markdown(html, year, day)
  # Extract title
  title_match = html.match(/<article class="day-desc"><h2>--- (Day \d+: .+?) ---<\/h2>/)
  title = title_match ? title_match[1] : "Day #{day}"

  # Extract all article content (both parts)
  articles = html.scan(/<article class="day-desc">(.*?)<\/article>/m)

  markdown = "# #{title}\n\n"
  markdown += "**Link:** https://adventofcode.com/#{year}/day/#{day}\n\n"
  markdown += "---\n\n"

  articles.each do |article|
    content = article[0]

    # Convert headers
    content.gsub!(/<h2>--- (.+?) ---<\/h2>/, "## \\1\n")
    content.gsub!(/<h2>(.+?)<\/h2>/, "## \\1\n")

    # Convert paragraphs
    content.gsub!(/<p>/, "\n")
    content.gsub!(/<\/p>/, "\n")

    # Convert code blocks
    content.gsub!(/<pre><code>(.*?)<\/code><\/pre>/m) { |match|
      code = $1
      code.gsub!(/&lt;/, '<')
      code.gsub!(/&gt;/, '>')
      code.gsub!(/&amp;/, '&')
      "\n```\n#{code.strip}\n```\n"
    }

    # Convert inline code
    content.gsub!(/<code>(.+?)<\/code>/, '`\1`')

    # Convert emphasis
    content.gsub!(/<em>(.+?)<\/em>/, '*\1*')
    content.gsub!(/<em class="star">(.+?)<\/em>/, '**\1**')

    # Convert lists
    content.gsub!(/<ul>(.*?)<\/ul>/m) do
      list = $1
      list.gsub!(/<li>(.+?)<\/li>/, "- \\1\n")
      "\n#{list}"
    end

    # Remove any remaining HTML tags
    content.gsub!(/<[^>]+>/, '')

    # Clean up HTML entities
    content.gsub!(/&quot;/, '"')
    content.gsub!(/&#39;/, "'")
    content.gsub!(/&lt;/, '<')
    content.gsub!(/&gt;/, '>')
    content.gsub!(/&amp;/, '&')

    # Clean up extra whitespace
    content.gsub!(/\n{3,}/, "\n\n")

    markdown += content.strip + "\n\n"
  end

  markdown.strip + "\n"
end

def fetch_input(year, day, session_cookie)
  uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.path)
  request['Cookie'] = "session=#{session_cookie}"

  response = http.request(request)

  if response.code != "200"
    puts "Failed to fetch input for day #{day}: HTTP #{response.code}"
    return nil
  end

  response.body
end

# Process each day
(1..25).each do |day|
  day_dir = "#{year}/day#{day}"
  readme_path = "#{day_dir}/README.md"

  # Check what needs to be fetched
  readme_exists = File.exist?(readme_path)
  input_path = "#{day_dir}/input.txt"
  input_exists = File.exist?(input_path)

  skip_readme = readme_exists
  skip_input = !should_fetch_input || input_exists

  if skip_readme && skip_input
    puts "Day #{day}: Already complete, skipping"
    next
  end

  puts "Fetching Day #{day}..."

  # Create directory if it doesn't exist
  FileUtils.mkdir_p(day_dir)

  # Fetch README if needed
  unless skip_readme
    html = fetch_problem(year, day, session_cookie)
    if html
      markdown = html_to_markdown(html, year, day)
      File.write(readme_path, markdown)
      puts "  README created ✓"
    end
  end

  # Fetch input if needed
  if should_fetch_input && !skip_input
    input_text = fetch_input(year, day, session_cookie)
    if input_text
      File.write(input_path, input_text)
      puts "  input.txt created ✓"
    end
  end

  # Be nice to the server
  sleep 1
end

puts "\nDone! Generated READMEs for #{year}"
