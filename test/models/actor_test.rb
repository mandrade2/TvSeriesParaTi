# == Schema Information
#
# Table name: actors
#
#  id          :integer          not null, primary key
#  name        :string
#  nacionality :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ActorTest < ActiveSupport::TestCase
  def setup
    @actor = actors(:one)
  end

  test 'nombres ' do
    nombres_correctos = %w[abigail Jhonson Maikel Jordan]
    nombres_correctos.each do |correcto|
      @actor.name = correcto
      assert @actor.valid?
    end
    nombres_correctos = %w[abig312ail J Mai_kel]
    nombres_correctos.each do |correcto|
      @actor.name = correcto
      assert_not @actor.valid?
    end
  end
end
