class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps

      # 複合インデックスと一意制約を追加
      t.index [:follower_id, :followed_id], unique: true
    end
  end
end
