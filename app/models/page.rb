class Page
  include Mongoid::Document
  field :title, type: String
  field :slogan, type: String
  field :text, type: String
  field :slug, type: String

  embeds_many :photos

  rails_admin do
    list do
      field :title
    end
    edit do
      field :title
      field :slogan
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
