class SearchJob < ApplicationJob
  queue_as :default

  def perform(slug)
    puts slug
    page = Page.find_by(slug: slug)
    page.update(slogan_1: DateTime.current)
    # Do something later
  end
end
