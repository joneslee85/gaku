module Gaku
  class HomeController < GakuController

    skip_authorization_check

    def index
      redirect_to new_user_session_path unless user_signed_in?
    end
  end
end
