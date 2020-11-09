class WorkingHoursController < ApplicationController

  def show
    @working_hour = WorkingHour.find(params[:id])
  end

  def update
    @working_hour = WorkingHour.find(params[:id])
    if !@working_hour
      @working_hour = WorkingHour.new task_id: params[:task_id], project_id: params[:project_id], secs: params[:secs]
      @working_hour.save
    else
      @working_hour.update(secs: params[:secs])
    end
    logger.debug @working_hour
  end

end
