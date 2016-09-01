class Page
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include Mongoid::Tree

  field :title, type: String
  field :RawName, type: String
  field :ArrivalId, type: String
  field :slogan_1, type: String
  field :slogan_2, type: String
  field :location_name, type: String
  field :location_text, type: String
  field :slug, type: String
  field :image, type: String
  field :visa, type: Boolean, default: true

  field :meta_title, type: String
  field :meta_keyword, type: String
  field :meta_description, type: String

  mount_uploader :image, PhotoUploader
  embeds_many :photos
  embeds_many :departures

  accepts_nested_attributes_for :departures, :allow_destroy => true

  #--
  # Валидации
  validates_presence_of :title, message: 'Название локации не может быть пустым!'
  validates_uniqueness_of :title, message: 'Название локации должно быть уникальным, введенное вами уже существует в системе!'
  validates_length_of :title, minimum: 1, maximum: 100, message: 'Название локации не может быть короче 1 символа и длиннее 100!'

  validates_presence_of :ArrivalId, message: 'Системный ID локации не может быть пустым!'
  validates_uniqueness_of :ArrivalId, message: 'Системный ID локации должен быть уникальным, введенный вами уже существует в системе!'

  validates_associated :parent, :children
  #++

  rails_admin do
    list do
      field :title
    end
    edit do
      field :title, :string do
        label 'Заголовок страницы'
      end
      field :slogan_1, :string do
        label 'Слоган 1'
      end
      field :slogan_2, :string do
        label 'Слоган 1'
      end
      field :ArrivalId, :string do
        label 'Системный ID локации'
      end
      field :location_name, :string do
        label 'Название локации'
      end
      field :meta_title, :string do
        label 'SEO заголовок (title)'
      end
      field :meta_keyword, :string do
        label 'SEO ключевые слова (keywords)'
      end
      field :meta_description, :string do
        label 'SEO описание (description)'
      end
      field :parent do
        label 'Родительская страница'
      end
      field :visa do
        label 'Нужна виза'
      end
      field :image, :carrierwave do
        label 'Фото в шапку страницы'
      end
      field :location_text, :ck_editor do
        label 'Описание'
      end
      field :departures do
        label 'Доступные города отправления'
      end
    end
  end

  def to_param
    slug
  end

  before_create :generate_slug
  before_update :generate_slug

  def start_search
    # if self.pricing.present?
    #   SearchJob.set(wait: 2.second).perform_later(self.slug)
    #   self.update(pricing: false)
    # end
    # SearchJob.perform_later(self.slug)
  end


  def self.get_data slug
    current_page = self.where({departures: {'$all' => [{'$elemMatch' => {slug: slug}}]}})[0]
    if current_page.present?
      current_page = current_page
      departure    = current_page.departures.find_by(slug: slug)

      title = departure.title.present? ? departure.title : current_page.title
      url   = departure.slug
      tours = departure.tours
      nav   = current_page.nav_data(departure.name)
    else
      current_page = self.find_by({slug: slug})


      title     = current_page.title
      url       = current_page.slug
      departure = nil
      tours     = nil
      nav       = current_page.nav_data("")
    end

    page = {
        'title'            => title,
        'slogan_1'         => current_page.slogan_1,
        'slogan_2'         => current_page.slogan_2,
        'location_name'    => current_page.location_name,
        'location_text'    => current_page.location_text,

        'meta_title'       => current_page.meta_title.present? ? current_page.meta_title : '',
        'meta_description' => current_page.meta_description,
        'meta_keyword'     => current_page.meta_keyword,
        'url'              => url,
        'photo'            => current_page.image.large.url.present? ? current_page.image.large.url : '',
        'photos'           => current_page.photos,

        'visa'             => current_page.visa,

        'ArrivalId'        => current_page.ArrivalId,
        'departure'        => departure,
        'tours'            => tours,

        'childrens'        => current_page.children,
        'nav'              => nav,
        'parent'           => current_page.ancestors
    }

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
    unless self.title.present?
      self.title = self.RawName
    end
    self.slug = self.title.parameterize

    self.departures.each do |departure|
      if departure.name.blank?
        departure.name = departure.RawName
      end
      if departure.title.blank?
        departure.title = departure.name
      end
      departure.slug = departure.title.parameterize
    end
  end

end
