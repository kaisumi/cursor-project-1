class CreateUsabilityTestResults < ActiveRecord::Migration[7.1]
  def change
    create_table :usability_test_results do |t|
      t.references :usability_test, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :completion_time, null: false
      t.boolean :success, null: false, default: false
      t.integer :difficulty_rating, null: false
      t.text :feedback
      
      t.timestamps
    end
  end
end
