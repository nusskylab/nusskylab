class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :name, null: false
      t.string :value, null: false

      t.timestamps null: false
    end
  end
end
