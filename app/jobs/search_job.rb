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
    # https://inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-09-04&StartVoyageDate=2016-09-01&TicketClass=0
    # http://test.inna.ru/#/packages/search/6733-2353-12.09.2016-13.09.2016-0-2-
    api_url = "https://inna.ru/"

    page = Page.find_by(slug: slug)

    months = [2]
    # months = [2, 3]

    if page.present?

      page.departures.each do |departure|
        tours = []
        months.each do |month|
          startVoyageDate = Date.current.weeks_since(month)
          endVoyageDate   = Date.current.weeks_since(month + 1)
          url_array       = [
              api_url,
              "api/v1/Packages/SearchHotels?",
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

            searchUrl = [
                api_url,
                "#/packages/search/",
                departure.DepartureId,
                "-",
                page.ArrivalId,
                "-",
                startVoyageDate.strftime('%d.%m.%Y'),
                "-",
                endVoyageDate.strftime('%d.%m.%Y'),
                "-0-2-"
            ].join

            tour = {
                StartVoyageDate: startVoyageDate,
                EndVoyageDate:   endVoyageDate,
                Price:           res_data['RecommendedPair']['Hotel']['PackagePrice'],
                SearchUrl:       searchUrl
                # Stars:           res_data[:RecommendedPair][:Hotel][:Stars]
            }
            p tour
            tours.push(tour)
          end

        end
        departure.update(tours: [])
        departure.update(tours: tours)

      end
    end

    # page.update(slogan_1: DateTime.current)
    # page.update(tours: json)
    # Do something later
  end
end
