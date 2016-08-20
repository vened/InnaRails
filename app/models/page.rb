class Page
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry
  field :title, type: String
  field :slogan_1, type: String
  field :slogan_2, type: String
  field :location_name, type: String
  field :location_text, type: String
  field :slug, type: String
  field :image, type: String
  field :tours, type: Object
  field :visa, type: Boolean, default: true

  mount_uploader :image, PhotoUploader
  embeds_many :photos
  embeds_many :locations

  accepts_nested_attributes_for :locations, :allow_destroy => true

  rails_admin do
    list do
      field :title
    end
    edit do
      field :title

      field :locations

      field :parent_id, :enum do
        enum do
          Page.all.map { |c| [ c.title, c.id ] }
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

  private
  def generate_slug
    self.slug = self.title.parameterize
    self.locations.each do |location|
      location.slug = self.title.parameterize + '-is-' + location.name.parameterize
    end
  end

end
