class PageChunk < ApplicationRecord
  belongs_to :website
  has_neighbors :embedding
end
