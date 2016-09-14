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
        departure = @page["departure"].present? ? p.departures.where(DepartureId: @page["departure"].DepartureId)[0] : nil
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

  def delete_tours
    # ищем страницу
    page = Page.where(ArrivalId: params["ArrivalId"])[0]

    if page.present?
      departure = page.departures.where(
          DepartureId: params["DepartureId"]
      )[0]

      if departure.present?
        departure.tours.delete_all
      else
        page.departures.each do |departure|
          departure.tours.delete_all
        end
      end
    end

    render json: {response: 'Туры успешно удалены'}, status: :ok
  end

  def update
    # locations = ActiveSupport::JSON.decode(params[:locations])
    if params[:locations].present?

      locations = JSON.parse params[:locations]

      locations["ArrivalList"].each do |location|

        # ищем страницу
        page = Page.where(
            ArrivalId: location["ArrivalId"]
        )[0]

        # если не находим, создаем новую
        if page.blank?
          page = Page.new(
              title:     location["RawName"],
              ArrivalId: location["ArrivalId"],
              RawName:   location["RawName"],
              pub:       false
          )
          page.save
        end

        location["departures"].each do |departure|

          current_departure = page.departures.where(
              DepartureId: departure["DepartureId"]
          )[0]

          if current_departure.blank?
            current_departure = page.departures.new(
                title:       "Туры в " + page.title + " из " + departure["RawName"],
                name:        departure["RawName"],
                RawName:     departure["RawName"],
                slug:        page.title.parameterize + "-" + departure["RawName"].parameterize,
                DepartureId: departure["DepartureId"]
            )
            current_departure.save
          end

          # current_departure.tours.delete_all

          departure["tours"].each do |tour|
            tour = Tour.new(
                StartVoyageDate: DateTime.parse(tour["StartVoyageDate"]),
                EndVoyageDate:   DateTime.parse(tour["EndVoyageDate"]),
                Price:           tour["Price"],
                Adult:           tour["SearchData"]["Adult"],
                Since:           DateTime.parse(tour["SearchData"]["Since"]),
                Till:            DateTime.parse(tour["SearchData"]["Till"]),
                TicketClass:     tour["SearchData"]["TicketClass"],
                ChildAges:       tour["SearchData"]["ChildAges"],
                Details:         tour["Details"],
                Host:            locations["Host"]
            )
            current_departure.tours << tour
          end


        end
      end

      render json: {response: 'Туры успешно импортированы'}, status: :ok
    else
      render json: {response: 'Ошибка при импорте, вы пытаетесь импортировать пустой объект'}, status: :bad_request
    end
  end

end
