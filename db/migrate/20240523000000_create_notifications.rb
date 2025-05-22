class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true
      t.string :action, null: false
      t.boolean :read, default: false
      t.timestamps
    end
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
