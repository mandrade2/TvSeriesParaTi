# == Schema Information
#
# Table name: series
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :string
#  country           :string
#  seasons           :integer
#  chapters_duration :integer
#  rating            :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class SeriesTest < ActiveSupport::TestCase
  def setup
    @serie1 = series(:one)
    @serie2 = series(:two)
    @actor = actors(:one)
    @director = directors(:two)
    @gender1 = genders(:one)
    @gender2 = genders(:two)
    @serie1.actors << @actor
    @serie2.genders << @gender1
  end

  test 'test de nombre' do
    nombres_de_series = %w[Las_mil_y_una_noches Abracadabra]
    nombres_de_series.each do |name|
      @serie1.name = name
      assert @serie1.valid?
    end
    nombres_de_no_series = [nil, '', 'meme' * 25]
    nombres_de_no_series.each do |no_name|
      @serie1.name = no_name
      assert_not @serie1.valid?
    end
  end

  test 'test de descripcion' do
    descripcion_de_series = %w[Las_mil_y_una_noches_es_una_grangrangrangranserie
                               Abracadabra_se_dice_que_es_aun_mejor_que_la_otra]
    descripcion_de_series.each do |name|
      @serie1.description = name
      assert @serie1.valid?
    end
    descripcion_de_no_series = [nil, '', 'meme' * 51]
    descripcion_de_no_series.each do |no_name|
      @serie1.description = no_name
      assert_not @serie1.valid?
    end
  end

  test 'actors' do
    assert_not @serie1.actors.where(id: @actor.id).empty?
  end

  test 'generos' do
    assert @serie2.genders.count == 1
    @serie2.genders << @gender2
    assert @serie2.genders.count == 2
    assert_raises(ActiveRecord::RecordNotUnique) do
      @serie2.genders << @gender2
    end
  end

  test 'director' do
    assert @serie2.directors.empty?
    @serie1.directors << @director
    assert_not @serie1.directors.empty?
    assert_raises(ActiveRecord::RecordNotUnique) do
      @serie1.directors << @director
    end
    assert @serie1.directors.count == 1
  end
end
