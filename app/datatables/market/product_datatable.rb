class Market::ProductDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: "Product.id" },
      sku: { source: "Product.sku" },
      name: { source: "Product.name" },
      stock: { source: "Product.stock" }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        id: record.id,
        sku: record.sku,
        name: record.name,
        stock: record.stock,
        DT_RowId: record.id, # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  def market
    @market ||= nil
  end

  def get_raw_records
    # insert query here
    # User.all
    return nil if @market.nil?

    Product.where(market_id: @market.id)
  end

end
