class CabinetsController < ApplicationController
  before_action :set_cabinet, only: [:show, :edit, :update, :destroy, :restore, :revert]

  # GET /cabinets
  # GET /cabinets.json
  def index
    @group = Group.find_by id: params[:group_id]
    @cabinets = @group.cabinets
  end

  # GET /cabinets/1
  # GET /cabinets/1.json
  def show
    @group = Group.find_by id: params[:group_id]
    @share_files = ShareFile.where(cabinet_id: @cabinet.id).order(version: :desc)
  end

  # GET /cabinets/new
  def new
  end

  # GET /cabinets/1/edit
  def edit
  end

  # POST /cabinets
  # POST /cabinets.json
  def create
    @cabinet = Cabinet.new(cabinet_params)
    @cabinet.group_id = params[:group_id]
    @cabinet.current_version = 1
    @cabinet.share_file.version = 1
    @cabinet.share_file.update_user_id = @current_user.id
    @cabinet.title = @cabinet.share_file.files[0].filename

    respond_to do |format|
      if @cabinet.save
        format.html { redirect_to group_cabinet_path(id: @cabinet.id, group_id: @cabinet.group_id), notice: 'Cabinet was successfully created.' }
        format.json { render :show, status: :created, location: @cabinet }
      else
        format.html { render :new }
        format.json { render json: @cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cabinets/1
  # PATCH/PUT /cabinets/1.json
  def update
    current_ver = ShareFile.limit(1).find_by(version: @cabinet.current_version)
    @file = ShareFile.new(
      cabinet_id: @cabinet.id,
      version: current_ver['version'] + 1,
      update_user_id: @current_user.id,
      comment: params[:cabinet][:share_file_attributes]['comment'],
      files: params[:cabinet][:share_file_attributes]['files']
    )
    # raise
    @cabinet.update_user_id = @current_user.id
    @cabinet.increment(:current_version)
    # raise
    respond_to do |format|
      if @cabinet.save! && @file.save
        format.html { redirect_to group_cabinet_path(id: @cabinet.id, group_id: @cabinet.group_id), notice: 'Cabinet was successfully updated.' }
        format.json { render :show, status: :ok, location: @cabinet }
      else
        format.html { render :edit }
        format.json { render json: @cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cabinets/1
  # DELETE /cabinets/1.json
  def destroy
    @cabinet.destroy
    respond_to do |format|
      format.html { redirect_to cabinets_url, notice: 'Cabinet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def restore
  end

  def revert
    # TODO: active_storageの複製ができればいいのだが
    @file = ShareFile.find_by(cabinet_id: @cabinet.id, version: params[:cabinet][:share_file_attributes][:restore_version]).dup
    @file.restore_version = @file.version
    @file.version = @cabinet.current_version + 1
    @file.update_user_id = @current_user.id
    @file.comment = params[:cabinet][:share_file_attributes]['comment']
    @file.files = @file.files.dup
    # raise
    @cabinet.update_user_id = @current_user.id
    @cabinet.increment(:current_version)
    # raise
    respond_to do |format|
      if @cabinet.save! && @file.save
        format.html { redirect_to group_cabinet_path(id: @cabinet.id, group_id: @cabinet.group_id), notice: 'Cabinet was successfully restored.' }
        format.json { render :show, status: :ok, location: @cabinet }
      else
        format.html { render :show }
        format.json { render json: @cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cabinet
      @cabinet = Cabinet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cabinet_params
      params.require(:cabinet).permit(
        :title,
        :folder_id,
        :current_version,
        :group_id,
        share_file_attributes: [
          :title,
          :memo,
          :version,
          :update_user_id,
          :filename,
          :comment,
          :restore_version,
          files: []
        ]
      )
    end
end
