#!/usr/bin/env ruby

require 'ripper'
require 'fileutils'

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

  # Write results as markdown
  results_path = File.join(who_dir, "results.md")
  File.open(results_path, 'w') do |f|
    f.puts "# #{problem_title}"
    f.puts ""
    f.puts "[Problem Link](#{problem_url})"
    f.puts ""
    f.puts "## Results"
    f.puts ""
    f.puts "| Part | Main Answer | Golf Answer | Golf Tokens |"
    f.puts "|------|-------------|-------------|-------------|"
    f.puts "| 1    | #{part1_answer || 'N/A'} | #{golf1_answer || 'N/A'} | #{golf1_tokens || 'N/A'} |"
    f.puts "| 2    | #{part2_answer || 'N/A'} | #{golf2_answer || 'N/A'} | #{golf2_tokens || 'N/A'} |"
  end

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
elsif ARGV.length == 1 && ARGV[0] != 'all'
  # Path format: 2015/day1/claude or /full/path/2015/day1/claude
  path = ARGV[0]
  if path =~ %r{(\d+)/day(\d+)/(me|claude)/?$}
    year, day, who = $1, $2, $3
    unless process_day(year, day, who)
      exit 1
    end
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
else
  puts "Error: Expected 3 arguments (year, day, who), a path, or 'all'"
  exit 1
end
