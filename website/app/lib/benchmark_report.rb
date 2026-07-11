module BenchmarkReport
  DISTROS = %w[ubuntu fedora debian].freeze

  DISTRO_META = {
    "ubuntu" => { name: "Ubuntu", version: "26.04 LTS", pts: "v10.8.6" },
    "fedora" => { name: "Fedora", version: "44", pts: "v10.8.6" },
    "debian" => { name: "Debian", version: "13", pts: "v10.8.6" }
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
