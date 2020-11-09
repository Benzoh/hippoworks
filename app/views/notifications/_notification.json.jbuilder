json.extract! notification, :id, :thread_type, :thread_id, :user_id, :is_read, :created_at, :updated_at
json.url notification_url(notification, format: :json)
