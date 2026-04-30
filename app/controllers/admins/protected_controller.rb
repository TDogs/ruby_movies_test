module Admins
  class ProtectedController < BaseController
    def profile
      render json: {
        id: current_admin.id,
        username: current_admin.username,
        role: current_admin.role
      }
    end
  end
end
