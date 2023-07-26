# frozen_string_literal: true

class UserEntity
  attr_accessor :id, :name, :email, :password_digest, :disabled_at, :created_at, :updated_at

  def initialize()
    #TODO: initialize attributes
  end
end