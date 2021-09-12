class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def is_a_gist?
    url.start_with?('https://gist.github.com')
  end
end
