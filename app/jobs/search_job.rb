require 'json'
require 'open-uri'

class SearchJob < ApplicationJob
  queue_as :default

  def perform(slug)
    # AddFilter:true
    # Adult:2
    # ArrivalId:2353
    # DepartureId:6733
    # EndVoyageDate:2016-09-11
    # StartVoyageDate:2016-09-01
    # TicketClass:0
    # http://test.inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-09-04&StartVoyageDate=2016-09-01&TicketClass=0
    # http://inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-11-04&StartVoyageDate=2016-11-01&TicketClass=0
    # "http://api.pages.inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-10-04&StartVoyageDate=2016-10-01&TicketClass=0"
    # "http://pages.inna.ru/api/v1"
    # http://test.inna.ru/#/packages/search/6733-2353-12.09.2016-13.09.2016-0-2-
    api_url = "https://api.inna.ru/api/v1/"
    url     = "https://inna.ru/"

    page = Page.find_by(slug: slug)

    months = [2,3]
    # months = [2, 3, 4, 5, 6, 7]

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

              # https://inna.ru/api/v1/Packages/HotelDetails?
              # HotelId=636061
              # HotelProviderId=2
              # TicketToId=3966639124
              # TicketBackId=3966639723
              # Filter[displayHotel]=636061
              # Filter[DepartureId]=6733
              # Filter[ArrivalId]=3005
              # Filter[StartVoyageDate]=2016-10-17
              # Filter[EndVoyageDate]=2016-10-20
              # Filter[TicketClass]=0
              # Filter[Adult]=2
              # Filter[HotelId]=636061
              # Filter[TicketId]=3966639124
              # Filter[TicketBackId]=3966639723
              # Filter[ProviderId]=2
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
                  "Filter[ProviderId]=#{res_data['RecommendedPair']['Hotel']['ProviderId']}&"
              ]
              res_data_details  = JSON.parse(open(url_array_details.join).read)


              if res_data_details.present?
                #:DepartureId-:ArrivalId-:StartVoyageDate-:EndVoyageDate-:TicketClass-:Adult-:Children?-:HotelId-:TicketId-:TicketBackId-:ProviderId
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
                ].join

                offer = {
                    SearchDate:      startVoyageDate.strftime('%d-%m-%Y') + "-" + endVoyageDate.strftime('%d-%m-%Y'),
                    StartVoyageDate: startVoyageDate,
                    EndVoyageDate:   endVoyageDate,
                    Price:           res_data_details['Hotel']['PackagePrice'],
                    SearchUrl:       searchUrl,
                    Hotel:           res_data_details['Hotel'],
                    AviaInfo:        res_data_details['AviaInfo'],
                }
                departure.offers.find_or_create_by(offer)
              end
              # offers.push(offer)
            end

          end
          # departure.update(offers: [])
          # departure.update(offers: offers)
        end
      end
    end

    # page.update(slogan_1: DateTime.current)
    # page.update(offers: json)
    # Do something later
  end
end
