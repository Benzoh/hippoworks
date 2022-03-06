module NotificationsHelper
  def get_notification_item_url(obj)
    case obj.thread_type
    when "comment"
      # TODO: リファクタリング
      if obj.parent_type == "project"
        gid = Project.find_by(id: obj.parent_id).group_id
        "/groups/#{gid}/projects/#{obj.parent_id}"
      elsif obj.parent_type == "calendar"
        model = Calendar.find_by(id: obj.parent_id)
        calendar_path(model)
      end
    when "project"
      gid = Project.find_by(id: obj.thread_id).group_id
      # TODO: リファクタリングできそうな気がする
      "/groups/#{gid}/projects/#{obj.thread_id}"
    when "calendar"
      model = Calendar.find_by(id: obj.thread_id)
      calendar_path(model)
    end
    # raise
  end
end
