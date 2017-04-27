# == Schema Information
#
# Table name: directors
#
#  id          :integer          not null, primary key
#  name        :string
#  nacionality :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DirectorTest < ActiveSupport::TestCase
  def setup
    @director = directors(:one)
  end

  test 'nombres ' do
    nombres_correctos = %w[abigail Jhonson Maikel Jordan]
    nombres_correctos.each do |correcto|
      @director.name = correcto
      assert @director.valid?
    end
    nombres_correctos = %w[abig312ail J Mai_kel]
    nombres_correctos.each do |correcto|
      @director.name = correcto
      assert_not @director.valid?
    end
  end
end
