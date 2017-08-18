class PlusganttDashboardController < ApplicationController
  menu_item :plusgantt_dashboard
  before_filter :find_optional_project

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  include PlusganttDashboardHelper

  def show
	Rails.logger.info("----------------show----------------------------")
	@dashboard = Dashboard.new(params)
	@dashboard.project = @project
  end
  
  def calculate
	Rails.logger.info("----------------calculate----------------------------")
	@dashboard = Dashboard.new(params)
	@dashboard.project = @project
	if params[:user_action] && params[:user_action] == 'calculate'
		issues_updated = @dashboard.recalculate_issue_end_date
		if issues_updated >= 0
			flash[:notice] = l(:label_issue_plural) + ": " + issues_updated.to_s
		else
			flash[:error] = @dashboard.error
		end
	end
	render action: 'show'
  end

end
