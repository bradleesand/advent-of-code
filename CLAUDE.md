# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Important Rules

- **NEVER read or examine files in `{year}/day{N}/me/` directories** - These contain the user's solutions and golf code, which you must not look at

## Repository Structure

This is an Advent of Code solutions repository organized by year, day, and who solved it:

```
{year}/
  day{N}/
    README.md       - Problem description with link to adventofcode.com
    input.txt       - Puzzle input (shared by all solutions)
    {who}/          - "me" for user solutions, "claude" for Claude solutions
      day{N}.rb        - Ruby solution for both parts
      day{N}.1.golf.rb - Code golf solution for part 1 (optional)
      day{N}.2.golf.rb - Code golf solution for part 2 (optional)
      results.yml      - YAML with answers and token counts
    scorecard.md     - Comparison table between "me" and "claude"
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
   ruby {year}/day{N}/claude/day{N}.rb < {year}/day{N}/input.txt
   ```

## Ruby Patterns

- All solutions read input from stdin
- Prefer input redirection (`ruby script.rb < input.txt`) over piping (`cat input.txt | ruby script.rb`)
- Use `gets` for single-line input (or `$stdin.read.strip` for explicit stdin)
- Use `$stdin.readlines.map(&:strip)` for multi-line input
- Solutions should handle both parts of the day's challenge

## Code Golf

After solving each day, create optimized "golf" solutions that minimize parser token count:

### Golf Files
- `day{N}.1.golf.rb` - Optimized solution for part 1
- `day{N}.2.golf.rb` - Optimized solution for part 2

### Scoring Rules
- **Tokens are counted by Ruby's parser** (via Ripper), NOT by character count
- Comments are FREE (not counted as tokens)
- Whitespace is FREE (newlines, spaces, indentation don't count)
- Variable name length DOES NOT MATTER (`x` and `very_long_name` both count as 1 token)
- Only valid solutions count (must produce correct answer)

### Best Practices for Golf Code
- Use descriptive variable names and add comments - they don't cost tokens!
- Format code with proper spacing and newlines for readability
- Focus on reducing actual operations, not shortening names
- Common optimizations:
  - Use `$<` instead of `$stdin` (both 1 token, but shorter to read)
  - Use character literals like `?x` instead of `'x'` (same tokens)
  - Chain operations: `array.map(&:to_i).sum`
  - Use blocks efficiently: `each`, `sum`, etc.

### Example
```ruby
# Bad: hard to read, same token count
p $<.sum{|l|d=l.split(?x).map(&:to_i).sort;d[0]*d[1]*3+d[1]*d[2]*2+d[0]*d[2]*2}

# Good: readable, same token count!
p $<.sum { |line|
  dimensions = line.split(?x).map(&:to_i).sort
  # Surface area + slack (smallest side)
  dimensions[0] * dimensions[1] * 3 + dimensions[1] * dimensions[2] * 2 + dimensions[0] * dimensions[2] * 2
}
```

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

The runner will:
- Execute the main solution and golf solutions
- Count tokens in golf solutions using Ripper
- Generate `results.yml` with all answers and token counts
- Update `{year}/scorecard.md` comparing "me" vs "claude" scores
