class PagesController < ApplicationController
  layout 'layouts/landing'

  def index
    @pages = Page.all
    # render :json => @pages
  end

  def show

    # @page = Page.find_by(slug: params[:id])
    # unless @page.present?
    @page       = Page.where({departures: {'$all' => [{'$elemMatch' => {slug: params[:id]}}]}})
    @page       = @page[0]

    # SearchJob.set(wait: 1.second).perform_later(@page.slug)

    @location = @page.departures.find_by(slug: params[:id])
    if @location.present?
      @page_title = @page.title + " из " + @location.name
    else
      @page_title = @page.title
    end
    # end

    @children   = @page.children
    @siblings   = @page.siblings
    if @children.present?
      @menu = @children
    else
      if @siblings.present?
        @menu= @siblings
      end
    end

    @parent = @page.ancestors
    if @parent.present?
      @page.ancestors.each do |p|
        add_breadcrumb p.title, page_path(p)
      end
      add_breadcrumb @page.title
    end
  end
end
