module BenchmarkReport
  DISTROS = %w[ubuntu fedora debian].freeze

  DISTRO_META = {
    "ubuntu" => { name: "Ubuntu", version: "24.04 LTS", pts: "v10.8.4" },
    "fedora" => { name: "Fedora", version: "41", pts: "v10.8.4" },
    "debian" => { name: "Debian", version: "12", pts: "v10.8.5" }
  }.freeze

  def self.meta(slug)
    DISTRO_META.fetch(slug)
  end

  def self.name_for(slug)
    m = meta(slug)
    "#{m[:name]} #{m[:version]}"
  end

  def self.markdown_path(slug)
    Rails.root.join("..", "benchmarks", slug, "#{slug}.md")
  end

  def self.markdown_for(slug)
    File.read(markdown_path(slug))
  end

  def self.parsed_for(slug)
    Parser.call(markdown_for(slug))
  end
end
