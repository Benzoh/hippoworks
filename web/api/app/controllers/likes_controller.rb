# frozen_string_literal: true

# like button
class LikesController < ApplicationController
  include NotificationUtility

  def create
    @like = Like.new(
      user_id: @current_user.id,
      thread_type: params[:thread_type],
      thread_id: params[:thread_id]
    )
    render :show if @like.save && save_like_notifications(@like)
  end

  def show
  end

  def destroy
    @like = Like.find_by(
      user_id: @current_user.id,
      thread_type: params[:thread_type],
      thread_id: params[:thread_id]
    )
    @like.destroy
    render :show
  end
end
