module Admin::UsersHelper
  def roles(user)
    roles = []
    roles << 'Administrator' if user.admin?
    roles << 'Regular' if user.regular?
    roles.join(', ')
  end
end
