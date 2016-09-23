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
    url = "https://inna.ru/"

    page   = Page.find_by(slug: slug)

    # months = [2]
    months = [2, 3, 4, 5, 6, 7]

    page.departures.each do |departure|
      offers = []
      months.each do |month|
        startVoyageDate = Date.current.weeks_since(month)
        endVoyageDate   = Date.current.weeks_since(month + 1)
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

          tour = {
              StartVoyageDate: startVoyageDate,
              EndVoyageDate:   endVoyageDate,
              Price:           res_data['RecommendedPair']['Hotel']['PackagePrice'],
              SearchUrl:       searchUrl
              # Stars:           res_data[:RecommendedPair][:Hotel][:Stars]
          }
          p tour
          offers.push(tour)
        end

      end
      departure.update(offers: [])
      departure.update(offers: offers)
    end

    # page.update(slogan_1: DateTime.current)
    # page.update(offers: json)
    # Do something later
  end
end
