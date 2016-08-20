require 'json'
require 'open-uri'

class SearchJob < ApplicationJob
  queue_as :default

  def perform(slug)
    puts slug
    # AddFilter:true
    # Adult:2
    # ArrivalId:2353
    # DepartureId:6733
    # EndVoyageDate:2016-09-11
    # StartVoyageDate:2016-09-01
    # TicketClass:0
    # http://test.inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-09-04&StartVoyageDate=2016-09-01&TicketClass=0

    page = Page.find_by(slug: slug)

    months = [2, 3, 4, 5, 6, 7, 8, 9]

    page.departures.each do |departure|
      months.each do |month|
        startVoyageDate = Date.current.weeks_since(month).strftime('%F')
        endVoyageDate = Date.current.weeks_since(month + 1).strftime('%F')
        url_array = [
            "http://test.inna.ru/api/v1/Packages/SearchHotels?",
            "AddFilter=true&",
            "Adult=2&",
            "ArrivalId=#{page.ArrivalId}&",
            "DepartureId=#{departure.DepartureId}&",
            "StartVoyageDate=#{startVoyageDate}&",
            "EndVoyageDate=#{endVoyageDate}&",
            "TicketClass=0"
        ]

        p url_array.join

        tours = JSON.parse(open(url_array.join).read)
        departure.update(tours: tours)
      end
    end

    # page.update(slogan_1: DateTime.current)
    # page.update(tours: json)
    # Do something later
  end
end
