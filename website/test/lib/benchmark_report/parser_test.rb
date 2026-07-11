require "test_helper"

class BenchmarkReport::ParserTest < ActiveSupport::TestCase
  SAMPLE = <<~MARKDOWN
    # Demo Benchmark Results

    Intro paragraph describing the run.

    ## Table of Contents
    1. [System Information](#system-information)

    ## System Information

    ### Hardware
    - **Processor**: 2 x Intel Core i5
    - **Memory**: `4096MB`

    ### Software
    - **OS**: Ubuntu 24.04
    - **Kernel**: 6.8.0-49-generic

    ---

    ## C-Ray Benchmark

    ### Test Identifier: `pts/c-ray-2.0.0`

    #### Title: C-Ray
    - **App Version**: 2.0
    - **Arguments**: `-s 1920x1080 -r 16`
    - **Description**: Resolution: 1080p - Rays Per Pixel: 16

    ### Detailed Run Times

    | Run | Time (ms) |
    |-----|-----------|
    | 1   | 100.0     |
    | 2   | 200.0     |
    | 3   | 300.0     |

    ### Summary Statistics
    - **Mean Time (ms)**: 200.0
    - **Median Time (ms)**: 200.0
    - **Standard Deviation (ms)**: 81.65
  MARKDOWN

  setup do
    @parsed = BenchmarkReport::Parser.call(SAMPLE)
  end

  test "renders the display name with version" do
    assert_equal "Ubuntu 24.04 LTS", BenchmarkReport.name_for("ubuntu")
    assert_equal "Fedora 41", BenchmarkReport.name_for("fedora")
    assert_equal "Debian 12", BenchmarkReport.name_for("debian")
  end

  test "exposes the Phoronix suite version per distro" do
    assert_equal "v10.8.4", BenchmarkReport.meta("ubuntu")[:pts]
    assert_equal "v10.8.5", BenchmarkReport.meta("debian")[:pts]
  end

  test "extracts the title and intro" do
    assert_equal "Demo Benchmark Results", @parsed[:title]
    assert_includes @parsed[:intro], "Intro paragraph describing the run."
  end

  test "parses hardware and software spec pairs and strips backticks" do
    assert_includes @parsed[:hardware], { key: "Processor", value: "2 x Intel Core i5" }
    assert_includes @parsed[:hardware], { key: "Memory", value: "4096MB" }
    assert_includes @parsed[:software], { key: "OS", value: "Ubuntu 24.04" }
  end

  test "keeps only the Benchmark H2 sections and slugifies their anchors" do
    assert_equal 1, @parsed[:sections].length
    assert_equal "C-Ray Benchmark", @parsed[:sections][0][:name]
    assert_equal "c-ray-benchmark", @parsed[:sections][0][:anchor]
  end

  test "parses a test's metadata, unit, run table, and summary stats" do
    test = @parsed[:sections][0][:tests][0]
    assert_equal "pts/c-ray-2.0.0", test[:identifier]
    assert_equal "C-Ray", test[:title]
    assert_equal "2.0", test[:app_version]
    assert_equal "-s 1920x1080 -r 16", test[:args]
    assert_includes test[:description], "Resolution: 1080p"
    assert_equal "ms", test[:unit]
    assert_equal [ { run: 1, value: 100.0 }, { run: 2, value: 200.0 }, { run: 3, value: 300.0 } ], test[:runs]
    assert_equal 200.0, test[:mean]
    assert_equal 200.0, test[:median]
    assert_in_delta 81.65, test[:stddev], 0.001
  end

  test "returns empty collections for non-benchmark input" do
    empty = BenchmarkReport::Parser.call("# Just A Title\n\nNo sections here.\n")
    assert_equal [], empty[:sections]
    assert_equal [], empty[:hardware]
  end

  test "every distro's committed markdown parses into at least one benchmark section with tests" do
    BenchmarkReport::DISTROS.each do |slug|
      parsed = BenchmarkReport.parsed_for(slug)
      assert parsed[:title].length.positive?, "#{slug}: expected a non-empty title"
      assert parsed[:sections].length.positive?, "#{slug}: expected at least one benchmark section"
      assert parsed[:sections][0][:tests].length.positive?, "#{slug}: expected the first section to have tests"
    end
  end
end
