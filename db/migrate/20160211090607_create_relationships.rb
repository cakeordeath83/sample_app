class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :follower_id
      t.string :integer
      t.integer :followed_id

      t.timestamps null: false
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # next index enforces uniqueness so that you can only follow someone once
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
