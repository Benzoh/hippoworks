class GroupConfigurationsController < ApplicationController
  before_action :set_group

  def index
  end

  def main
  end

  def theme
  end

  def mail
  end

  def event

  end

  def facility

  end

  def status

  end

  private
    def set_group
      @group = Group.find_by id: params[:group_id]
    end

end