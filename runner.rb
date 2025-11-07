#!/usr/bin/env ruby

require 'ripper'
require 'fileutils'
require 'yaml'

def count_tokens(code)
  # Use Ripper to tokenize the Ruby code
  # Filter out ignored tokens like whitespace and comments
  tokens = Ripper.lex(code).reject do |pos, type, token|
    [:on_sp, :on_nl, :on_ignored_nl, :on_comment].include?(type)
  end
  tokens.length
end

def run_solution(path, input_file)
  return nil unless File.exist?(path)
  return nil unless File.exist?(input_file)
  output = `ruby #{path} < #{input_file} 2>&1`
  return nil unless $?.success?
  output.strip
end

def process_day(year, day, who)
  day_dir = File.join(year, "day#{day}")
  who_dir = File.join(day_dir, who)

  unless Dir.exist?(who_dir)
    puts "Directory not found: #{who_dir}"
    return false
  end

  puts "Processing #{year}/day#{day}/#{who}..."

  # Extract problem title and URL from README.md at day level
  readme_path = File.join(day_dir, "README.md")
  problem_title = "Day #{day}"
  problem_url = "https://adventofcode.com/#{year}/day/#{day}"

  if File.exist?(readme_path)
    readme_content = File.read(readme_path)
    # Extract title from first line (format: "# Day N: Title")
    if readme_content.lines.first =~ /^#\s*Day\s*\d+:\s*(.+)/
      problem_title = "Day #{day}: #{$1.strip}"
    end
    # Extract URL from second non-empty line
    readme_content.lines.each do |line|
      if line =~ /(https:\/\/adventofcode\.com\/\d+\/day\/\d+)/
        problem_url = $1
        break
      end
    end
  end

  # Get input file path
  input_file = File.join(day_dir, "input.txt")
  unless File.exist?(input_file)
    puts "  Warning: input.txt not found"
    return false
  end

  # Run main solution
  main_solution = File.join(who_dir, "day#{day}.rb")
  main_output = run_solution(main_solution, input_file)

  unless main_output
    puts "  Warning: Could not run main solution"
    return false
  end

  # Parse main solution output
  part1_answer = nil
  part2_answer = nil
  main_output.lines.each do |line|
    if line =~ /Part 1:\s*(.+)/
      part1_answer = $1.strip
    elsif line =~ /Part 2:\s*(.+)/
      part2_answer = $1.strip
    end
  end

  # Run and count golf solutions
  golf1_path = File.join(who_dir, "day#{day}.1.golf.rb")
  golf2_path = File.join(who_dir, "day#{day}.2.golf.rb")

  golf1_answer = nil
  golf1_tokens = nil
  if File.exist?(golf1_path)
    golf1_output = run_solution(golf1_path, input_file)
    golf1_answer = golf1_output&.strip
    golf1_code = File.read(golf1_path, encoding: 'UTF-8')
    golf1_tokens = count_tokens(golf1_code)
  end

  golf2_answer = nil
  golf2_tokens = nil
  if File.exist?(golf2_path)
    golf2_output = run_solution(golf2_path, input_file)
    golf2_answer = golf2_output&.strip
    golf2_code = File.read(golf2_path, encoding: 'UTF-8')
    golf2_tokens = count_tokens(golf2_code)
  end

  # Write results as YAML
  results_path = File.join(who_dir, "results.yml")
  results_data = {
    'year' => year,
    'day' => day.to_i,
    'who' => who,
    'title' => problem_title.sub(/^Day \d+: /, ''),
    'url' => problem_url,
    'results' => {
      'main' => {
        'part1' => part1_answer,
        'part2' => part2_answer
      },
      'golf' => {
        'part1' => {
          'answer' => golf1_answer,
          'tokens' => golf1_tokens
        },
        'part2' => {
          'answer' => golf2_answer,
          'tokens' => golf2_tokens
        }
      }
    }
  }

  File.write(results_path, results_data.to_yaml)
  puts "  Results written to #{results_path}"
  true
end

def find_all_days
  days = []
  Dir.glob("*/day*/*").each do |path|
    if path =~ %r{(\d+)/day(\d+)/(me|claude)$}
      year, day, who = $1, $2.to_i, $3
      days << [year, day, who]
    end
  end
  days.sort_by { |year, day, who| [year, day, who] }
end

def generate_scorecard(year)
  results_by_day = {}

  # Load all YAML results for the year
  Dir.glob("#{year}/day*/*/results.yml").each do |path|
    data = YAML.load_file(path)
    day = data['day']
    who = data['who']

    results_by_day[day] ||= {}
    results_by_day[day]['title'] = data['title']
    results_by_day[day]['url'] = data['url']
    results_by_day[day][who] = data['results']['golf']
  end

  return if results_by_day.empty?

  # Generate scorecard markdown
  scorecard_path = "#{year}/scorecard.md"
  File.open(scorecard_path, 'w') do |f|
    f.puts "# #{year} Code Golf Scorecard"
    f.puts ""
    f.puts "| Day | Problem | Me P1 | Claude P1 | Me P2 | Claude P2 |"
    f.puts "|-----|---------|-------|-----------|-------|-----------|"

    results_by_day.keys.sort.each do |day|
      data = results_by_day[day]
      title = data['title']

      me_p1 = data.dig('me', 'part1', 'tokens')
      claude_p1 = data.dig('claude', 'part1', 'tokens')
      me_p2 = data.dig('me', 'part2', 'tokens')
      claude_p2 = data.dig('claude', 'part2', 'tokens')

      # Check if answers are valid (not nil/empty)
      me_p1_valid = data.dig('me', 'part1', 'answer').to_s != ''
      claude_p1_valid = data.dig('claude', 'part1', 'answer').to_s != ''
      me_p2_valid = data.dig('me', 'part2', 'answer').to_s != ''
      claude_p2_valid = data.dig('claude', 'part2', 'answer').to_s != ''

      # Format with bold for winners (only if both answers are valid)
      me_p1_str = if !me_p1_valid
        '-'
      elsif me_p1 && claude_p1 && me_p1 < claude_p1 && claude_p1_valid
        "**#{me_p1}**"
      elsif me_p1
        me_p1.to_s
      else
        '-'
      end

      claude_p1_str = if !claude_p1_valid
        '-'
      elsif me_p1 && claude_p1 && claude_p1 < me_p1 && me_p1_valid
        "**#{claude_p1}**"
      elsif claude_p1
        claude_p1.to_s
      else
        '-'
      end

      me_p2_str = if !me_p2_valid
        '-'
      elsif me_p2 && claude_p2 && me_p2 < claude_p2 && claude_p2_valid
        "**#{me_p2}**"
      elsif me_p2
        me_p2.to_s
      else
        '-'
      end

      claude_p2_str = if !claude_p2_valid
        '-'
      elsif me_p2 && claude_p2 && claude_p2 < me_p2 && me_p2_valid
        "**#{claude_p2}**"
      elsif claude_p2
        claude_p2.to_s
      else
        '-'
      end

      f.puts "| #{day} | #{title} | #{me_p1_str} | #{claude_p1_str} | #{me_p2_str} | #{claude_p2_str} |"
    end

    # Calculate totals
    me_wins = 0
    claude_wins = 0
    ties = 0

    results_by_day.each do |day, data|
      ['part1', 'part2'].each do |part|
        me_tokens = data.dig('me', part, 'tokens')
        claude_tokens = data.dig('claude', part, 'tokens')
        me_answer = data.dig('me', part, 'answer').to_s
        claude_answer = data.dig('claude', part, 'answer').to_s

        # Only count if both have valid answers
        next unless me_tokens && claude_tokens && me_answer != '' && claude_answer != ''

        if me_tokens < claude_tokens
          me_wins += 1
        elsif claude_tokens < me_tokens
          claude_wins += 1
        else
          ties += 1
        end
      end
    end

    f.puts ""
    f.puts "## Summary"
    f.puts ""
    f.puts "- Me: #{me_wins} wins"
    f.puts "- Claude: #{claude_wins} wins"
    f.puts "- Ties: #{ties}"
  end

  puts "Scorecard written to #{scorecard_path}"
end

# Main execution
if ARGV.empty?
  puts "Usage: #{$0} <year> <day> <who>"
  puts "       #{$0} <path>"
  puts "       #{$0} all"
  puts ""
  puts "Examples:"
  puts "  #{$0} 2015 1 claude"
  puts "  #{$0} 2015/day1/claude"
  puts "  #{$0} all"
  exit 1
end

if ARGV[0] == 'all'
  days = find_all_days
  if days.empty?
    puts "No days found"
    exit 1
  end

  success_count = 0
  days.each do |year, day, who|
    if process_day(year, day, who)
      success_count += 1
    end
  end

  puts ""
  puts "Processed #{success_count}/#{days.length} days successfully"

  # Generate scorecards for each year
  years = days.map { |year, day, who| year }.uniq
  years.each do |year|
    generate_scorecard(year)
  end
elsif ARGV.length == 1 && ARGV[0] != 'all'
  # Path format: 2015/day1/claude or /full/path/2015/day1/claude
  path = ARGV[0]
  if path =~ %r{(\d+)/day(\d+)/(me|claude)/?$}
    year, day, who = $1, $2, $3
    unless process_day(year, day, who)
      exit 1
    end
    generate_scorecard(year)
  else
    puts "Error: Could not parse path '#{path}'"
    puts "Expected format: <year>/day<day>/<who>"
    puts "Hint: Make sure you have a Ruby solution file open, not a config file."
    exit 1
  end
elsif ARGV.length == 3
  # Individual arguments format: 2015 1 claude
  year, day, who = ARGV
  unless process_day(year, day, who)
    exit 1
  end
  generate_scorecard(year)
else
  puts "Error: Expected 3 arguments (year, day, who), a path, or 'all'"
  exit 1
end
