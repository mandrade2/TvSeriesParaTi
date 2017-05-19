# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  name       :string
#  duration   :string
#  series_id  :integer
#  user_id    :integer
#  rating     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
