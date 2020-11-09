json.extract! invite, :id, :mail_to, :account_id, :state, :created_at, :updated_at
json.url invite_url(invite, format: :json)
