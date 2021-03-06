require 'spec_helper'
include Warden::Test::Helpers

module Gaku::Testing::AuthHelpers

  module Controller
    def as(user)
      @request.env['devise.mapping'] = ::Devise.mappings[:admin] if user == 'admin'
      sign_in create("#{user.to_sym}_user")
    end
  end

  module Request
    def as(user)
      login_as create("#{user.to_sym}_user"), scope: :user
    end
  end

end

RSpec.configure do |config|
  config.include Gaku::Testing::AuthHelpers::Controller, type: :controller
  config.include Gaku::Testing::AuthHelpers::Request, type: :request
end

