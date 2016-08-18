class PagesController < ApplicationController
  layout 'layouts/landing'
  def index
    @pages = Page.all
  end

  def show
    @page = Page.find_by(slug: params[:id])
  end
end
