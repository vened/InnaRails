require 'search/search_offers'
class SearchJob < ApplicationJob
  queue_as :default

  def perform(slug)

    page = Page.find_by(slug: slug)

    if page.departures.present?
      page.departures.each do |departure|
        if departure.DepartureId.present?

          if page.dates.present?
            search = SearchOffers.new(page.dates, page.ArrivalId, departure.DepartureId, departure.slug)
          else
            search = SearchOffers.new(nil, page.ArrivalId, departure.DepartureId, departure.slug)
          end


          offers = search.offers

          if offers.present?
            departure.offers.delete_all
            offers.each do |offer|
              departure.offers.find_or_create_by(offer)
            end
          end

        end
      end
    end
  end
end
