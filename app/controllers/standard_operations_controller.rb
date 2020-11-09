class StandardOperationsController < ApplicationController

  def create
    @standard_operation = StandardOperation.new(
      task: params[:task],
      state: params[:state],
      project_id: params[:project_id]
    )

    if @standard_operation.save
      render :show
    else
      raise
    end
  end

  def update
    @standard_opetation = StandardOperation.find(params[:standard_operation_id])
    @standard_opetation.update( state: params[:state] )
  end

  def show
  end

  def destroy
    set_standard_operation
    if @standard_operation.destroy
      render :delete
    else
      raise
    end
  end

  private
    def set_standard_operation
      @standard_operation = StandardOperation.find(params[:id])
    end

    def standard_operation_params
      params.require(:standard_operation).permit(:task, :project_id)
    end
end
