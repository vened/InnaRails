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

    json = JSON.parse(open("http://test.inna.ru/api/v1/Packages/SearchHotels?AddFilter=true&Adult=2&ArrivalId=18820&DepartureId=6733&EndVoyageDate=2016-09-04&StartVoyageDate=2016-09-01&TicketClass=0").read)

    puts json
    p "====="
    page = Page.find_by(slug: slug)
    page.update(slogan_1: DateTime.current)
    # page.update(tours: json)
    # Do something later
  end
end
