class AddMatricNumberToUser < ActiveRecord::Migration
  def up
    add_column :users, :matric_number, :string, default: ''
  end

  def down
    remove_column :users, :matric_number, :string
  end
end
