# coding: utf-8
class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  authorize_resource

  private

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
  
end