class AddSlideLinkToMentors < ActiveRecord::Migration
  def change
	add_column :mentors, :slide_link, :string, default:0
  end
end