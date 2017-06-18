# == Schema Information
#
# Table name: favorites
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  favorable_id   :integer
#  favorable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorable, polymorphic: true
end
