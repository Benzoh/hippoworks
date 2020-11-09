class TimersController < ApplicationController

  include ConvertTime

  def update

    secs = to_sec params[:h], params[:m], params[:s]
    logger.debug 'DEBUG >>>'
    logger.debug secs
    logger.debug '<<< DEBUG'

    _timer = Timer.find_by(params[:project_id])
    if _timer == false
      @timer = Timer.new(
        h: params[:h],
        m: params[:m],
        s: params[:s],
        secs: secs,
        project_id: params[:project_id]
      )
    else
      @timer = _timer
      @timer.update(
        h: params[:h],
        m: params[:m],
        s: params[:s],
        secs: secs
      )
    end
    redirect_to controller: 'projects', action: "dashboard", id: params[:project_id]
  end

end
