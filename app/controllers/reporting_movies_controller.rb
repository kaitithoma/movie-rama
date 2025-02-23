# frozen_string_literal: true

class ReportingMoviesController < BaseController
  skip_before_action :authorize_request, only: %i[overview]

  def overview
    @overview = Reporting::Movies::Overview.call(overview_args)

    respond_to do |format|
      format.html { render :overview }
      format.json { render json: @overview, status: :ok }
    end
  end

  private

  def overview_args
    {
      limit: params[:per_page],
      page: params[:page],
      sort_by: params[:sort_by],
      sort_order: params[:sort_order],
      user_id: params[:user_id],
      current_user_id: current_user&.id
    }
  end
end
