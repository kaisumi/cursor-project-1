class CreateUsabilityTests < ActiveRecord::Migration[7.1]
  def change
    create_table :usability_tests do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :task, null: false
      t.string :token, null: false
      
      t.timestamps
    end
    
    add_index :usability_tests, :token, unique: true
  end
end
