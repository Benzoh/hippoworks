# frozen_string_literal: true

# get fixed link.
class FixedLinksController < ApplicationController
  def get
    logger.debug 'DEBUG >>>'
    logger.debug params
    logger.debug '<<< DEBUG'
    comment = Comment.find_by(id: params[:comment_id])
    if comment['parent_type'] == 'project'
      @project = Project.find_by(id: comment['parent_id'])
    elsif comment['parent_type'] == 'calendar'
      @calendar = Calendar.find_by(id: comment['parent_id'])
    end
  end
end
