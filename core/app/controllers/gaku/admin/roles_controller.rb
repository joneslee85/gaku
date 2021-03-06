module Gaku
  class Admin::RolesController < Admin::BaseController

    #load_and_authorize_resource class: Role

    respond_to :js,   only: %i( new create edit update destroy )
    respond_to :html, only: :index

    before_action :set_role, only: %i( edit update destroy )

    def index
      @roles = Role.all
      @count = Role.count
      respond_with @roles
    end

    def new
      @role = Role.new
      respond_with @role
    end

    def create
      @role = Role.new(role_params)
      @role.save
      @count = Role.count
      respond_with @role
    end

    def edit
    end

    def update
      @role.update(role_params)
      respond_with @role
    end

    def destroy
      @role.destroy
      @count = Role.count
      respond_with @role
    end

    private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end

  end
end
