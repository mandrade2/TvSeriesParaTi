class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can %i[update manage destroy update_children
             manage_children destroy_children], User
      can %i[manage update destroy], Series
      can %i[manage update destroy], News
      can %i[manage update destroy], Chapter
      can %i[manage destroy], Comment
    elsif user.user?
      can :read, :all
      can %i[manage], Series
      can %i[manage], News
      can %i[manage], Chapter
      can %i[update_children manage_children destroy_children], User
    elsif user.child?
      can :read, :all
    end
  end
end
