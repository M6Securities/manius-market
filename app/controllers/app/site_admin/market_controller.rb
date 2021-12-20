# frozen_string_literal: true

module App
  module SiteAdmin
    class MarketController < SiteAdminController

      def datatable
        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[id display_name path_name created_at].include? sort_name

        filtered_count = Market.all.size
        records = Market.all.select(:id, :display_name, :path_name, :created_at).order(sort_name => sort_dir).limit(requested_length).offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: Market.all.size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end

    end
  end
end