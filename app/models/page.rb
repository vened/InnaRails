class Page
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry
  field :title, type: String
  field :slogan, type: String
  field :text, type: String
  field :slug, type: String
  field :image, type: String

  mount_uploader :image, PhotoUploader
  embeds_many :photos

  rails_admin do
    list do
      field :title
    end
    edit do
      field :title
      field :parent_id, :enum do
        enum do
          Page.all.map { |c| [ c.title, c.id ] }
        end
      end
      field :slogan
      field :image, :carrierwave
      field :text, :ck_editor
    end
  end

  def to_param
    slug
  end

  before_create :generate_slug
  before_update :generate_slug

  private
  def generate_slug
    self.slug = self.title.parameterize
  end

end
