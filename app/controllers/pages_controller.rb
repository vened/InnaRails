class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'layouts/landing'

  def index
    @pages = Page.roots.order_by({"u_at" => -1})
    # render :json => @pages
  end

  def show
    @page = Page.get_data(params[:id])

    if @page["parent"].present?
      @page["parent"].each do |p|
        departure = p.departures.where(DepartureId: @page["departure"].DepartureId)[0]
        if departure.present?
          add_breadcrumb departure.title ? departure.title : p.title, page_path(departure.slug)
        else
          add_breadcrumb p.title, page_path(p)
        end
      end
      add_breadcrumb @page["title"]
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

        p "---------------------"
        p departure
        dep = page.departures.find_or_create_by({
                                                    RawName:     departure["RawName"],
                                                    DepartureId: departure["DepartureId"]
                                                })

        if dep.name.blank?
          dep.update(name: departure["RawName"])
        end

        tours = []
        departure["tours"].each do |tour|
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

        if departure["isDefault"] == 'true'
          dep.update(
              isDefault: departure["isDefault"],
              slug:      page.title.parameterize,
              tours:     []
          )
        else
          dep.update(
              isDefault: departure["isDefault"],
              slug:      page.title.parameterize + '-' + departure["RawName"].parameterize,
              tours:     []
          )
        end
        dep.update(tours: tours)

      end
      pages << page
    end

    render json: {}, status: :ok
  end

end
