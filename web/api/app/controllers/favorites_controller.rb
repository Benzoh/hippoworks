# frozen_string_literal: true

class FavoritesController < ApplicationController

  def index
    # TODO: ページネーション？
    @favorites = @current_account.favorites.order(created_at: :desc)
  end

  def create
    if (params[:record_type] == 'comment')
      parent = Comment.find_by(id: params[:record_id])
      render :show if @current_account.favorites.create(
        record_type: params[:record_type],
        record_id: params[:record_id],
        parent_type: parent.parent_type,
        parent_id: parent.parent_id
      )
    else
      render :show if @current_account.favorites.create(
        record_type: params[:record_type],
        record_id: params[:record_id],
        parent_type: params[:record_type],
        parent_id: params[:record_id]
      )
    end

  end

  def show
  end

  def destroy
    if (params[:record_type] == 'comment')
      comment = Comment.find_by(id: params[:record_id])
      @favorite = @current_account.favorites.find_by(
        record_type: params[:record_type],
        record_id: params[:record_id],
        parent_type: comment.parent_type,
        parent_id: comment.parent_id
      )
    else
      @favorite = @current_account.favorites.find_by(
        record_type: params[:record_type],
        record_id: params[:record_id],
        parent_type: params[:record_type],
        parent_id: params[:record_id]
      )
    end
    render :show if @favorite.destroy
  end
end
