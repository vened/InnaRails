class PagesController < ApplicationController
  layout 'layouts/landing'

  def index
    @pages = Page.all
    # render :json => @pages
  end

  def show
    @page      = Page.find_by({departures: {'$all' => [{'$elemMatch' => {slug: params[:id]}}]}})
    @departure = @page.departures.find_by(slug: params[:id])
    if @departure.name.present?
      @nav        = @page.nav_data(@departure.name)
      @page_title = @page.title + " " + @departure.name
    else
      @nav        = @page.nav_data("")
      @page_title = @page.title
    end

    @parent = @page.ancestors
    if @parent.present?
      @page.ancestors.each do |p|
        departure = p.departures.find_by(name: @departure.name)
        if departure.present?
          add_breadcrumb p.title + " " + departure.name, page_path(departure.slug)
        else
          add_breadcrumb p.title, page_path(p)
        end
      end
      add_breadcrumb @page_title
    end

    # SearchJob.set(wait: 1.second).perform_later(@page.slug)
  end
end
