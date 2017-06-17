class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorable, polymorphic: true
end
