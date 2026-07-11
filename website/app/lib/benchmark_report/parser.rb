module BenchmarkReport
  # Parses the Phoronix-style markdown writeups under benchmarks/<distro>/<distro>.md
  # into the same shape the old Next.js site rendered (site/lib/benchmarks.ts).
  module Parser
    KEY_VALUE_LINE = /^-\s+\*\*(.+?)\*\*:\s*(.*)$/

    module_function

    def call(markdown)
      title_match = markdown.match(/^#\s+(.+)$/)
      intro_match = markdown.match(/^#\s+[^\n]+\n+([\s\S]*?)\n+(?=^##\s)/)

      hw_match = markdown.match(/### Hardware\s*\n+([\s\S]*?)\n+###/)
      sw_match = markdown.match(/### Software\s*\n+([\s\S]*?)\n+---/)

      h2_sections = markdown.split(/(?=^##\s+)/)
      sections = h2_sections
        .select { |s| /^##\s+.*Benchmark/.match?(s) }
        .map { |section| parse_section(section) }

      {
        title: title_match ? title_match[1].strip : "",
        intro: intro_match ? intro_match[1].strip : "",
        hardware: parse_spec_list(hw_match ? hw_match[1] : ""),
        software: parse_spec_list(sw_match ? sw_match[1] : ""),
        sections: sections
      }
    end

    def parse_section(section)
      name_match = section.match(/^##\s+(.+)$/)
      name = name_match ? name_match[1].strip : "Benchmark"
      test_blocks = section.split(/(?=### Test Identifier:)/)[1..] || []
      {
        name: name,
        anchor: slugify(name),
        tests: test_blocks.map { |block| parse_test(block) }
      }
    end

    def parse_test(block)
      ident_match = block.match(/### Test Identifier:\s*`?([^`\n]+)`?/)
      title_match = block.match(/#### Title:\s*(.+)/)
      table_match = block.match(/### Detailed Run (?:Times|Values)\s*\n+([\s\S]*?)(?=\n###|\n---|\z)/)

      {
        identifier: ident_match ? ident_match[1].strip : "",
        title: title_match ? title_match[1].strip : "",
        description: find_key_value(block, /^Description$/),
        app_version: find_key_value(block, /^App Version$/),
        args: find_key_value(block, /^Arguments$/),
        unit: detect_unit(block),
        runs: table_match ? parse_table(table_match[1]) : [],
        mean: find_numeric(block, /^Mean/),
        median: find_numeric(block, /^Median/),
        stddev: find_numeric(block, /^Standard Deviation/)
      }
    end

    def parse_spec_list(text)
      text.to_s.split("\n").filter_map do |line|
        m = line.match(KEY_VALUE_LINE)
        next unless m

        { key: m[1].strip, value: strip_backticks(m[2].strip) }
      end
    end

    def parse_table(text)
      lines = text.split("\n").select { |l| l.strip.start_with?("|") }
      return [] if lines.length < 3

      lines[2..].filter_map do |line|
        cells = line.split("|").map(&:strip).reject(&:empty?)
        run = Integer(cells[0], exception: false)
        value = Float(cells[1], exception: false)
        next unless run && value

        { run: run, value: value }
      end
    end

    def find_key_value(block, key_regex)
      block.split("\n").each do |line|
        m = line.match(KEY_VALUE_LINE)
        next unless m
        return strip_backticks(m[2].strip) if key_regex.match?(m[1])
      end
      ""
    end

    def find_numeric(block, key_regex)
      Float(find_key_value(block, key_regex), exception: false) || 0
    end

    def detect_unit(block)
      m = block.match(/\*\*Mean (?:Time|Value) \(([^)]+)\)\*\*/)
      m ? m[1] : ""
    end

    def strip_backticks(s)
      s.sub(/\A`(.*)`\z/, '\1')
    end

    def slugify(s)
      s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "")
    end
  end
end
