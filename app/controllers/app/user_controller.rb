# frozen_string_literal: true

module App
  # edit users in the current market, current_user needs to be admin
  class UserController < AppController
    before_action :find_user, except: %i[datatable]

    def index
      render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)
    end

    def show
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)

      @user_market_permissions = UserMarketPermission.find_by(user_id: @user.id, market_id: @current_market.id)
    end

    def update
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)

      if @user.id == current_user.id
        flash[:warning] = 'You cannot edit your own permissions'
        return render :permissions, status: :unprocessable_entity
      end

      # unless current user is an admin
      unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)
        flash[:error] = 'You are not authorized to update user permissions'
        return render :permissions, status: :unprocessable_entity
      end

      @user_market_permissions = UserMarketPermission.find_by(user_id: @user.id, market_id: @current_market.id)
      if @user_market_permissions.nil?
        flash[:error] = 'Cannot edit permissions'
        return render :permissions, status: :unprocessable_entity
      end

      permission_keys = %i[
        owner
        admin
        view_products
        edit_products
      ].freeze

      safe_params = if params[:update].nil?
                      {}
                    else
                      params[:update].permit(permission_keys)
                    end

      permission_keys.each do |key|
        safe_params[key] = safe_params[key] == 'on'
      end

      if safe_params[:owner]
        unless current_user.permission?(UserMarketPermission::OWNER, @current_market)
          flash[:error] = 'You cannot set ownership unless you are an owner'
          return render :permissions, status: :unprocessable_entity
        end

        if @user_market_permissions.update(formatted_permissions: UserMarketPermission.format_permissions([UserMarketPermission::OWNER]))
          flash[:success] = 'Permissions updated'
          return render :permissions, status: :ok
        end
      end

      if safe_params[:admin]
        # rubocop:disable Style/SoleNestedConditional
        # Needs to see if admin is true first before updating the permissions
        if @user_market_permissions.update(formatted_permissions: UserMarketPermission.format_permissions([UserMarketPermission::ADMIN]))
          flash[:success] = 'Permissions updated'
          return render :permissions, status: :ok
        end
        # rubocop:enable Style/SoleNestedConditional
      end

      new_permissions = [UserMarketPermission::MEMBER]
      permission_keys.each do |key|
        next unless safe_params[key]

        case key
        when :view_products
          new_permissions.append UserMarketPermission::VIEW_PRODUCTS
        when :edit_products
          new_permissions.append UserMarketPermission::EDIT_PRODUCTS
        end
      end

      if @user_market_permissions.update(formatted_permissions: UserMarketPermission.format_permissions(new_permissions))
        flash[:success] = 'Permissions updated'
        render :permissions, status: :ok
      else
        flash[:error] = 'Cannot update permissions'
        render :permissions, status: :unprocessable_entity
      end
    end

    def permissions
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)

      @user_market_permissions = UserMarketPermission.find_by(user_id: @user.id, market_id: @current_market.id)
    end

    def invite_user_to_market
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::ADMIN, @current_market)

      @email = params[:invite][:email]
      @user = User.find_by(email: @email)

      if @email.blank?
        flash[:error] = 'Email cannot be blank'
        return render :invite_user_to_market_view, status: :unprocessable_entity
      end

      if @user.nil?
        flash[:warning] = "User with email #{@email} may not exist or be currently active"
        return render :invite_user_to_market_view, status: :unprocessable_entity
      end

      @permission = @user.user_market_permissions.new(
        market_id: @current_market.id,
        formatted_permissions: UserMarketPermission.format_permissions([UserMarketPermission::MEMBER])
      )

      if @permission.save
        flash[:success] = "User #{@user.email} has been invited to #{@current_market.display_name}"
        @permission = nil
        render :invite_user_to_market_view, status: :ok
      else
        flash[:error] = "User #{@user.email} could not be invited to #{@current_market.display_name}"
        render :invite_user_to_market_view, status: :unprocessable_entity
      end
    end

    def datatable
      requested_length = params[:length].to_i
      requested_start  = params[:start].to_i

      sort_col = params['order']['0']['column'] # eg 0 for column 0
      sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
      sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
      search_value = params['search']['value']

      return unless %w[id email display_name last_activity_at].include? sort_name

      user_columns_select = %w[user.id user.email user.display_name user.last_activity_at].freeze

      filtered_count = UserMarketPermission.where(market_id: @current_market.id).joins(:user).where(user: { enabled: true }).size
      records = UserMarketPermission.where(market_id: @current_market.id).joins(:user).where(user: { enabled: true }).select(user_columns_select).order(sort_name => sort_dir).limit(requested_length).offset(requested_start)

      ActiveRecord::Base.include_root_in_json = false

      payload = {
        draw: params[:draw],
        recordsTotal: UserMarketPermission.where(market_id: @current_market.id).joins(:user).where(user: { enabled: true }).size,
        recordsFiltered: filtered_count,
        data: records.as_json
      }

      render json: payload, status: :ok
    end

    private

    def find_user
      @user = if !params[:id].blank?
                User.find_by(id: params[:id])
              elsif !params[:user_id].blank?
                User.find_by(id: params[:user_id])
              else
                User.new
              end
    end

  end
end
