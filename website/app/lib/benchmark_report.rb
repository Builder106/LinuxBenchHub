module BenchmarkReport
  DISTROS = %w[ubuntu fedora debian].freeze
  ARCHES = %w[x86 arm64].freeze
  DEFAULT_ARCH = "x86"

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

  # x86 captures live under benchmarks/<slug>/<slug>.md; arm64 captures live
  # under benchmarks/<slug>-arm64/<slug>-arm64.md, same naming pattern one
  # directory over, since the arm64 leg is the same distro on different CPU
  # architecture rather than a distinct distro.
  def self.dir_for(slug, arch: DEFAULT_ARCH)
    arch == "arm64" ? "#{slug}-arm64" : slug
  end

  def self.markdown_path(slug, arch: DEFAULT_ARCH)
    dir = dir_for(slug, arch: arch)
    Rails.root.join("..", "benchmarks", dir, "#{dir}.md")
  end

  def self.markdown_for(slug, arch: DEFAULT_ARCH)
    File.read(markdown_path(slug, arch: arch))
  end

  def self.parsed_for(slug, arch: DEFAULT_ARCH)
    Parser.call(markdown_for(slug, arch: arch))
  end
end
