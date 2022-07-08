# frozen_string_literal: true

module App
  module SiteAdmin
    # user controller for site admins
    class UserController < SiteAdminController
      before_action :find_user

      def update
        # safe params
        safe_params = params.require(:update).permit(:enabled, :site_admin)

        %i[enabled site_admin].each do |key|
          safe_params[key] = safe_params[key] == 'on'
        end

        if @user.update safe_params
          render :show
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def datatable
        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'].to_s # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[id email display_name last_activity_at].include? sort_name

        filtered_count = User.all.size
        records = User.all.select(:id, :email, :display_name, :last_activity_at).order(sort_name => sort_dir).limit(requested_length).offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: User.all.size,
          recordsFiltered: filtered_count,
          data: records.as_json
        }

        render json: payload, status: :ok
      end

      private

      def find_user
        @user = if params[:id].blank?
                  User.new
                else
                  User.find(params[:id])
                end
      end

    end
  end
end
