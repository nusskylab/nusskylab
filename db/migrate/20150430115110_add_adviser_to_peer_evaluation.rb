class AddAdviserToPeerEvaluation < ActiveRecord::Migration
  def change
    add_reference :peer_evaluations, :adviser, index: true
    add_foreign_key :peer_evaluations, :advisers
    add_column :peer_evaluations, :owner_type, :string, default: 'teams'
  end
end
