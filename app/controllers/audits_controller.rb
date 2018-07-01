class AuditsController < ApplicationController
  #before_action :get_current_user_audits, only: :index
  before_action :set_filter_for_audits, only: [:index]

  def index
  end

  private
  def get_current_user_audits
    @audits = current_user.audits.order(created_at: :desc).limit(50)
  end

  def set_filter_for_audits
    audits_scope = Audit.order(created_at: :desc).limit(50)
    audits_scope = audits_scope.by_employee(params[:filter]) if params[:filter].present?
    @audits = smart_listing_create(
      :audits,
      audits_scope,
      partial: "audits/audits_list",
      default_sort: {id: 'desc'}
    )
  end


end
