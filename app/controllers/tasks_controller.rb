class TasksController < ApplicationController
  def create
    @task = Task.new(
      name: params[:name],
      state: params[:state],
      project_id: params[:project_id]
    )
    @task.build_working_hour(
      project_id: params[:project_id]
    )

    if @task.save
      render :show
    else
      raise
    end
  end

  def update
    @task = Task.find(params[:task_id])
    @task.update( state: params[:state] )
  end

  def show
  end

  def destroy
    set_task
    if @task.destroy
      render :delete
    else
      raise
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :project_id, :state)
    end
end
