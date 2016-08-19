class PagesController < ApplicationController
  layout 'layouts/landing'

  def index
    @pages = Page.all
  end

  def show
    @page   = Page.find_by(slug: params[:id])
    @parent = @page.parent
    if @parent.present?
      add_breadcrumb @parent.title, page_path(@parent)
      add_breadcrumb @page.title
    end
  end
end
