# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is an Advent of Code solutions repository organized by year, day, and who solved it:

```
{year}/
  day{N}/
    README.md       - Problem description with link to adventofcode.com
    input.txt       - Puzzle input (shared by all solutions)
    {who}/          - "me" for user solutions, "claude" for Claude solutions
      day{N}.rb       - Ruby solution for both parts
      day{N}.1.golf.rb - Code golf solution for part 1 (optional)
      day{N}.2.golf.rb - Code golf solution for part 2 (optional)
      results.md      - Results table with answers and token counts
```

## Workflow for New Days

When the user asks to work on a new day:

1. **Fetch the problem**: Use WebFetch to get the problem description from `https://adventofcode.com/{year}/day/{N}`

2. **Create directory structure**:
   ```bash
   mkdir -p {year}/day{N}/claude
   ```

3. **Create README.md** in `{year}/day{N}/`:
   - Title format: `# Day {N}: {Problem Title}`
   - Link to the problem: `https://adventofcode.com/{year}/day/{N}`
   - Full problem description for both Part 1 and Part 2
   - Include all examples

4. **Create empty input.txt** in `{year}/day{N}/` - User will paste their puzzle input

5. **Create solution file** in `{year}/day{N}/claude/day{N}.rb`:
   - Include shebang: `#!/usr/bin/env ruby`
   - Read input from stdin
   - Handle both Part 1 and Part 2 in the same file
   - Output format: `puts "Part 1: #{answer}"` and `puts "Part 2: #{answer}"`

6. **Run solution**:
   ```bash
   cat {year}/day{N}/input.txt | ruby {year}/day{N}/claude/day{N}.rb
   ```

## Ruby Patterns

- All solutions read input from stdin
- Use `$stdin.read.strip` for single-line input
- Use `$stdin.readlines.map(&:strip)` for multi-line input
- Solutions should handle both parts of the day's challenge

## Runner

Use `./runner.rb` to run solutions and generate results:
```bash
./runner.rb <year> <day> <who>   # Run specific solution
./runner.rb <path>                # Run from directory path
./runner.rb all                   # Run all solutions

# Examples:
./runner.rb 2015 1 claude
./runner.rb 2015/day1/claude
./runner.rb all
```
