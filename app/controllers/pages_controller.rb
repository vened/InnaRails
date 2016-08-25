class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'layouts/landing'

  def index
    @pages = Page.all
    # render :json => @pages
  end

  def show
    @page      = Page.find_by({departures: {'$all' => [{'$elemMatch' => {slug: params[:id]}}]}})
    @departure = @page.departures.find_by(slug: params[:id])
    if @departure.name.present?
      @nav        = @page.nav_data(@departure.name)
      @page_title = @page.title + " " + @departure.name
    else
      @nav        = @page.nav_data("")
      @page_title = @page.title
    end

    @childrens = @page.children

    @parent = @page.ancestors
    if @parent.present?
      @page.ancestors.each do |p|
        departure = p.departures.find_by(name: @departure.name)
        if departure.present?
          add_breadcrumb p.title + " " + departure.name, page_path(departure.slug)
        else
          add_breadcrumb p.title, page_path(p)
        end
      end
      add_breadcrumb @page_title
    end

    # SearchJob.set(wait: 1.second).perform_later(@page.slug)
  end

  def update
    # locations = ActiveSupport::JSON.decode(params[:locations])

    locations = JSON.parse params[:locations]
    p locations
    p "==="
    pages = []
    locations["ArrivalList"].each do |location|
      page = Page.find_or_create_by(ArrivalId: location["ArrivalId"], RawName: location["RawName"])

      location["departures"].each do |departure|
        departure["name"] = departure["RawName"]

        dep = page.departures.find_or_create_by({
                                              name:        departure["RawName"],
                                              RawName:     departure["RawName"],
                                              DepartureId: departure["DepartureId"]
                                          })
        tours = []
        departure["tours"].each do |tour|
          p "===="
          p tour["StartVoyageDate"]
          p DateTime.parse(tour["StartVoyageDate"])
          p DateTime.parse(tour["StartVoyageDate"])
          tour = {
              StartVoyageDate: DateTime.parse(tour["StartVoyageDate"]),
              EndVoyageDate:   DateTime.parse(tour["EndVoyageDate"]),
              Price:           tour["Price"],
              Adult:           tour["SearchData"]["Adult"],
              Since:           DateTime.parse(tour["SearchData"]["Since"]),
              Till:            DateTime.parse(tour["SearchData"]["Till"]),
              TicketClass:     tour["SearchData"]["TicketClass"],
              ChildAges:       tour["SearchData"]["ChildAges"]
          }
          p tour
          tours.push(tour)
        end

        dep.update(tours: [])
        dep.update(tours: tours)

      end
      pages << page
    end

    render json: {}, status: :ok
  end

end
