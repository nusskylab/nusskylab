class AddExtrasAndOrderToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :extras, :text
    add_column :questions, :order, :integer
    Question.all.each do |question|
      question.order = question.id
      question.save
    end
  end

  def down
    remove_column :questions, :extras, :text
    remove_column :questions, :order, :integer
  end
end
