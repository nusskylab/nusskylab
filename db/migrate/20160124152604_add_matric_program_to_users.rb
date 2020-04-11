class AddMatricProgramToUsers < ActiveRecord::Migration
  def up
    add_column :users, :program_of_study, :integer, default: 0
    add_column :users, :self_introduction, :text, default: ''
  end

  def down
    remove_column :users, :program_of_study, :integer
    remove_column :users, :self_introduction, :text
  end
end
