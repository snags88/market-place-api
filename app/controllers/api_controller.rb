class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  # add global API settings like security/authentication

  include Authenticatable
end
