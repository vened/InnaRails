class OffersController < ApplicationController
  # skip_before_action :verify_authenticity_token
  layout 'layouts/landing'


  def show
    @page = Page.get_data(params[:departureSlug])

    @departure = @page['departure']
    @offer     = @departure.offers.where(SearchDate: params[:SearchDate])[0]

    if @page["parent"].present?
      @page["parent"].each do |p|
        departure = @page["departure"].present? ? p.departures.where(DepartureId: @page["departure"].DepartureId)[0] : nil
        if departure.present?
          add_breadcrumb departure.title ? departure.title : p.title, page_path(departure.slug)
        else
          add_breadcrumb p.title, page_path(p)
        end
      end
      add_breadcrumb @page["title"], page_path(@page["url"])


      month_1 = l @offer[:StartVoyageDate], :format => :custom_month
      month_2 = l @offer[:EndVoyageDate], :format => :custom_month
      if month_1 == month_2
        month_1_format = l @offer[:StartVoyageDate], :format => :custom_short
        month_2_format = l @offer[:EndVoyageDate], :format => :custom
      else
        month_1_format = l @offer[:StartVoyageDate], :format => :custom
        month_2_format = l @offer[:EndVoyageDate], :format => :custom
      end


      add_breadcrumb "#{month_1_format}-#{month_2_format}"
    end

    render json: @offer
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
