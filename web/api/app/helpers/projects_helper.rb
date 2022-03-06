module ProjectsHelper

  def get_delivery_date(project_id = @project.id)
    project = Project.find_by id: project_id
    color = 'light'
    time = Time.zone.now

    if project.delivery_date.today?
      color = 'danger'
    elsif project.delivery_date < 1.week.since
      color = 'warning'
    end

    html = "<span class='badge badge-#{ color }'>#{ project.delivery_date.strftime("%Y/%m/%d") }</span>"
  end

  def get_formatted_time(task_id, project_id)
    working_hour = WorkingHour.find_by(task_id: task_id)
    if working_hour.blank?
      working_hour = WorkingHour.new(task_id: task_id)
      working_hour.save
      # raise
      html = <<~EOS
        [<span class="hour">00</span>:<span class="min">00</span>:<span class="sec">00</span>]
      EOS
      return html.html_safe
    end
    t = working_hour.secs
    time = Time.at(t).utc.strftime("%H:%M:%S").split(':')
    # raise
    html = <<~EOS
      [<span class="hour">#{time[0]}</span>:<span class="min">#{time[1]}</span>:<span class="sec">#{time[2]}</span>]
    EOS
    html.html_safe
  end

end
