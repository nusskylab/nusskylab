class AddDisplayOrderToFacilitators < ActiveRecord::Migration
  def change
    add_column :facilitators, :display_order, :integer, null:false, default:0
  end
end
