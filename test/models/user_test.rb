# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  role                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'usuario valido' do
    assert @user.valid?
  end

  test 'nombre presente' do
    @user.name = '    '
    assert_not @user.valid?
  end

  test 'no acepta nombres cortos' do
    @user.name = 'a'
    assert_not @user.valid?
  end

  test 'no acepta nombres demasiado largos' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'no acepta nombre con formato invalido' do
    invalid_names = %w[rigo.berto pe_dro 123ejemplo]
    invalid_names.each do |name|
      @user.name = name
      assert_not @user.valid?
    end
  end

  test 'no acepta nombres de usuarios repetidos' do
    @user.username = users(:two).username
    assert_not @user.valid?
  end

  test 'no acepta nombres de usuario cortos ni largos' do
    @user.username = 'a1234'
    assert_not @user.valid?
    @user.username = 'a1234' * 20
    assert_not @user.valid?
  end

  # test 'no acepta roles fuera de la lista' do
  #   invalid_roles = %w[papa suadmin common_user]
  #   invalid_roles.each do |role|
  #     @user.role = role
  #     assert_not @user.valid?
  #   end
  # end
end
