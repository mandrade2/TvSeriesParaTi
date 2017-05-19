require 'test_helper'

class SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @series = series(:one)
  end

  test 'should get index' do
    get series_index_url
    assert_response :success
  end

  test 'should get new' do
    get new_series_url
    assert_response :redirect #:success
  end

  test 'should create series' do
    assert_no_difference('Series.count') do
      post series_index_url, params: { series: {
        chapters_duration: @series.chapters_duration,
        country: @series.country,
        description: @series.description
      } }
    end

    assert_redirected_to new_user_session_url #series_url(Series.last)
  end

  test 'should show series' do
    get series_url(@series)
    assert_response :success
  end

  test 'should get edit' do
    get edit_series_url(@series)
    assert_response :redirect #:success
  end

  test 'should update series' do
    patch series_url(@series), params: { series: {
      chapters_duration: @series.chapters_duration,
      country: @series.country,
      description: @series.description,
      name: @series.name,
      rating: @series.rating,
      seasons: @series.seasons
    } }
    assert_redirected_to new_user_session_url #series_url(@series)
  end

  test 'should destroy series' do
    assert_no_difference('Series.count') do
      delete series_url(@series)
    end

    assert_redirected_to new_user_session_url #series_index_url
  end
end
