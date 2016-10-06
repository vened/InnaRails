require 'json'
require 'open-uri'

class SearchJob < ApplicationJob
  queue_as :default

  def perform(slug)

    if Rails.env.production?
      api_url = "http://api.inna.ru/api/v1/"
      url     = "https://inna.ru/"
      months  = [2, 3, 4, 5, 6, 7]
    else
      api_url = "https://api.inna.ru/api/v1/"
      url     = "http://lh.inna.ru/"
      months  = [20]
    end

    page = Page.find_by(slug: slug)

    if page.departures.present?
      page.departures.each do |departure|
        # departure.update(offers: [])
        departure.offers.delete_all
        # departure.offers = []
        # departure.offers.save
        if departure.DepartureId.present?
          months.each do |month|
            date            = Date.current.weeks_since(month)
            startVoyageDate = date.beginning_of_week(:saturday)
            endVoyageDate   = date.end_of_week
            url_array       = [
                api_url,
                "Packages/SearchHotels?",
                "AddFilter=true&",
                "Adult=2&",
                "ArrivalId=#{page.ArrivalId}&",
                "DepartureId=#{departure.DepartureId}&",
                "StartVoyageDate=#{startVoyageDate.strftime('%F')}&",
                "EndVoyageDate=#{endVoyageDate.strftime('%F')}&",
                "TicketClass=0"
            ]

            res_data = JSON.parse(open(url_array.join).read)

            if res_data.present?

              url_array_details = [
                  api_url,
                  "Packages/HotelDetails?",
                  "HotelId=#{res_data['RecommendedPair']['Hotel']['HotelId']}&",
                  "HotelProviderId=#{res_data['RecommendedPair']['Hotel']['ProviderId']}&",
                  "TicketToId=#{res_data['RecommendedPair']['AviaInfo']['VariantId1']}&",
                  "TicketBackId=#{res_data['RecommendedPair']['AviaInfo']['VariantId2']}&",
                  "Filter[displayHotel]=#{res_data['RecommendedPair']['Hotel']['HotelId']}&",
                  "Filter[DepartureId]=#{departure.DepartureId}&",
                  "Filter[ArrivalId]=#{page.ArrivalId}&",
                  "Filter[StartVoyageDate]=#{startVoyageDate.strftime('%Y-%m-%d')}&",
                  "Filter[EndVoyageDate]=#{endVoyageDate.strftime('%Y-%m-%d')}&",
                  "Filter[TicketClass]=0&",
                  "Filter[Adult]=2&",
                  "Filter[HotelId]=#{res_data['RecommendedPair']['Hotel']['HotelId']}&",
                  "Filter[TicketId]=#{res_data['RecommendedPair']['AviaInfo']['VariantId1']}&",
                  "Filter[TicketBackId]=#{res_data['RecommendedPair']['AviaInfo']['VariantId2']}&",
                  "Filter[ProviderId]=#{res_data['RecommendedPair']['Hotel']['ProviderId']}&",
                  "Rooms=true",
              ].join

              res_data_details = JSON.parse(open(url_array_details).read)

              if res_data_details.present?

                searchDate = startVoyageDate.strftime('%d-%m-%Y') + "-" + endVoyageDate.strftime('%d-%m-%Y')

                searchUrl = [
                    url,
                    "#/packages/details/",
                    departure.DepartureId,
                    "-",
                    page.ArrivalId,
                    "-",
                    startVoyageDate.strftime('%d.%m.%Y'),
                    "-",
                    endVoyageDate.strftime('%d.%m.%Y'),
                    "-0-2--",
                    res_data['RecommendedPair']['Hotel']['HotelId'],
                    "-",
                    res_data['RecommendedPair']['AviaInfo']['VariantId1'],
                    "-",
                    res_data['RecommendedPair']['AviaInfo']['VariantId2'],
                    "-",
                    res_data['RecommendedPair']['Hotel']['ProviderId'],
                    "?departureSlug=#{departure.slug}&SearchDate=#{searchDate}",
                ].join

                offer = {
                    SearchDate:      searchDate,
                    StartVoyageDate: startVoyageDate,
                    EndVoyageDate:   endVoyageDate,
                    Price:           res_data_details['Hotel']['PackagePrice'],
                    SearchUrl:       searchUrl,
                    Hotel:           res_data_details['Hotel'],
                    Rooms:           res_data_details['Rooms'],
                    AviaInfo:        res_data_details['AviaInfo'],
                }
                departure.offers.find_or_create_by(offer)
              end
            end
          end
        end
      end
    end
  end
end
