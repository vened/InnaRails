class OffersController < ApplicationController
  # skip_before_action :verify_authenticity_token
  layout 'layouts/landing'


  def show
    @page = Page.get_data(params[:departureSlug])

    @departure = @page['departure']
    @offer = @departure.offers.where(SearchDate: params[:SearchDate])[0]
    # if @page["parent"].present?
    #   @page["parent"].each do |p|
    #     departure = @page["departure"].present? ? p.departures.where(DepartureId: @page["departure"].DepartureId)[0] : nil
    #     if departure.present?
    #       add_breadcrumb departure.title ? departure.title : p.title, page_path(departure.slug)
    #     else
    #       add_breadcrumb p.title, page_path(p)
    #     end
    #   end
    #   add_breadcrumb @page["title"]
    # end

  end
end
