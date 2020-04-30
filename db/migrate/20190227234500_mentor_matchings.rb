class CreateMentorMatchings < ActiveRecord::Migration
    def change
      create_table :mentor_matchings do |t|
        t.integer :team_id
        t.integer :mentor_id
        t.integer :choice_ranking
        t.boolean :mentor_accepted
        t.integer :cohort
      end
    end
end 