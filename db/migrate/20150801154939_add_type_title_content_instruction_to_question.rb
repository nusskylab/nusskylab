class AddTypeTitleContentInstructionToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :type, :string
    add_column :questions, :title, :text
    add_column :questions, :content, :text
    add_column :questions, :instruction, :text
  end
end
