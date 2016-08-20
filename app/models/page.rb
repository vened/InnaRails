class Page
  include Mongoid::Document
  include Mongoid::Tree
  # include Mongoid::Ancestry
  # has_ancestry

  field :title, type: String
  field :ArrivalId, type: String
  field :slogan_1, type: String
  field :slogan_2, type: String
  field :location_name, type: String
  field :location_text, type: String
  field :slug, type: String
  field :image, type: String
  field :visa, type: Boolean, default: true

  mount_uploader :image, PhotoUploader
  embeds_many :photos
  embeds_many :departures

  accepts_nested_attributes_for :departures, :allow_destroy => true

  rails_admin do
    list do
      field :title
    end
    edit do
      field :title
      field :ArrivalId

      field :departures

      field :parent_id, :enum do
        enum do
          Page.all.map { |c| [c.title, c.id] }
        end
      end
      field :slogan_1
      field :slogan_2
      field :image, :carrierwave
      field :location_name
      field :visa
      field :location_text, :ck_editor
    end
    # configure :locations do
    #   visible(true)
    # end
  end

  def to_param
    slug
  end

  before_create :generate_slug
  before_update :generate_slug, :start_search

  def start_search
    #   SearchJob.perform_later(self.slug)
    #   SearchJob.set(wait: 2.second).perform_later(self.slug)
  end


  def nav_data name
    Page.collection.aggregate(
        [
            {
                '$match' => {
                    parent_id:  {'$in' => [self._id]},
                    departures: {'$all' => [{'$elemMatch' => {name: name}}]}
                }
            },
            {'$unwind' => '$departures'},
            {'$project' =>
                 {
                     title:         1,
                     slug:          "$departures.slug",
                     name:          {'$concat': ["$title", " ", "$departures.name"]},
                     DepartureName: "$departures.name"
                 }
            },
            {'$match' =>
                 {
                     DepartureName: {'$eq': name}
                 }
            }
        ]
    )
  end


  private
  def generate_slug
    logger.debug '============='
    logger.debug 'generate_slug'
    self.slug   = self.title.parameterize
    parent_page = self.parent
    if parent_page.present?
      parent_page.departures.each do |departure|
        self.departures.find_or_create_by({
                                              name:        departure.name,
                                              DepartureId: departure.DepartureId
                                          })
      end
    end
    self.departures.each do |departure|
      if departure.isDefault.present?
        departure.slug = self.title.parameterize
      else
        departure.slug = self.title.parameterize + '-is-' + departure.name.parameterize
      end
    end
  end

end
