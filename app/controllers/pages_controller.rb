class PagesController < ApplicationController
  layout 'layouts/landing'

  def index
    @pages = Page.all
    # render :json => @pages
  end

  def show
    @page = Page.find_by(slug: params[:id])

    @children = @page.children
    @siblings = @page.siblings
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
