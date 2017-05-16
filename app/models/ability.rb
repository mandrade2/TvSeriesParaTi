class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can %i[update manage destroy update_children
             manage_children destroy_children], User
      can %i[manage update destroy], Series
    elsif user.user?
      can :read, :all
      can %i[update_children manage_children destroy_children], User
    elsif user.child?
      can :read, :all
    end
  end
end
