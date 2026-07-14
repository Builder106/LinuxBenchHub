class BenchmarksController < ApplicationController
  def show
    slug = params[:distro]
    raise ActionController::RoutingError, "Unknown distro" unless DistroBenchmark.valid_slug?(slug)

    @distro = DistroBenchmark.load(slug)
    @meta = @distro.meta
  end
end
