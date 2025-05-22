module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      if session_token = cookies.encrypted[:session_token]
        User.find_by(session_token: session_token)
      else
        reject_unauthorized_connection
      end
    end
  end
end
