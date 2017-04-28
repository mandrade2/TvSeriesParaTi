class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can %i[update manage destroy], User
    elsif user.user?
      can :read, :all
    end
  end
end
