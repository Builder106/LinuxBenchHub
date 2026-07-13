class ShowcaseController < ApplicationController
  layout "showcase"

  def index
    ubuntu = BenchmarkReport.parsed_for("ubuntu")
    @sample_tests = ubuntu[:sections].flat_map { |s| s[:tests] }
    @sample_hardware = ubuntu[:hardware]
    @sample_software = ubuntu[:software]

    tests_by_distro = BenchmarkReport::DISTROS.index_with do |slug|
      BenchmarkReport.parsed_for(slug)[:sections].flat_map { |s| s[:tests] }
    end
    @distro_cray = tests_by_distro.transform_values do |tests|
      tests.find { |t| t[:identifier].start_with?("pts/c-ray") }
    end
  end

  def show
    @distro = params[:distro]
    @arch = params[:arch].presence || BenchmarkReport::DEFAULT_ARCH
    unless BenchmarkReport::DISTROS.include?(@distro) && BenchmarkReport::ARCHES.include?(@arch)
      raise ActionController::RoutingError, "unknown distro/arch #{@distro}/#{@arch}"
    end

    @meta = BenchmarkReport.meta(@distro)
    @parsed = BenchmarkReport.parsed_for(@distro, arch: @arch)
  end
end
