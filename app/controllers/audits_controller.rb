class AuditsController < ApplicationController
  before_action :get_current_user_audits, only: :index

  def index
  end

  private
  def get_current_user_audits
    @audits = current_user.audits
  end


end
