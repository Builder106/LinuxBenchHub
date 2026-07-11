class ShowcaseController < ApplicationController
  layout "showcase"

  def index
    ubuntu = BenchmarkReport.parsed_for("ubuntu")
    @sample_tests = ubuntu[:sections].flat_map { |s| s[:tests] }

    tests_by_distro = BenchmarkReport::DISTROS.index_with do |slug|
      BenchmarkReport.parsed_for(slug)[:sections].flat_map { |s| s[:tests] }
    end
    @distro_cray = tests_by_distro.transform_values do |tests|
      tests.find { |t| t[:identifier].start_with?("pts/c-ray") }
    end
  end

  def show
    @distro = params[:distro]
    unless BenchmarkReport::DISTROS.include?(@distro)
      raise ActionController::RoutingError, "unknown distro #{@distro}"
    end

    @meta = BenchmarkReport.meta(@distro)
    @parsed = BenchmarkReport.parsed_for(@distro)
  end
end
