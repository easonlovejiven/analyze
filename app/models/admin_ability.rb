class AdminAbility
	include CanCan::Ability

	def initialize(user)
		if user.nil?
			cannot :manage, :all
		elsif user.genre == 1 or user.genre == 2 or user.genre == 3
			can :manage, :all
		else
			cannot :manage, :all
		end
	end
end