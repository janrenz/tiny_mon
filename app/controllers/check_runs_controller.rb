class CheckRunsController < ApplicationController
  before_filter :login_required
  before_filter :find_account
  before_filter :find_site
  before_filter :find_health_check
  
  def index
    @check_runs = @health_check.recent_check_runs
    respond_to do |format|
      format.html { render :partial => "/check_runs/activity" if request.xhr? }
      format.png { send_data(CheckRunGraph.new(@check_runs.reverse).render, :disposition => 'inline', :type => 'image/png', :filename => "check_runs.png") }
    end
  end
  
  def show
    @check_run = @health_check.check_runs.find(params[:id])
  end
  
  def create
    @check_run = @health_check.check!
    redirect_to site_health_check_check_run_path(@site, @health_check, @check_run)
  end
  
protected
  def find_account
    @account = current_user.current_account
  end

  def find_site
    @site = @account.sites.find_by_permalink!(params[:site_id])
  end

  def find_health_check
    @health_check = @site.health_checks.find_by_permalink!(params[:health_check_id])
  end
end
