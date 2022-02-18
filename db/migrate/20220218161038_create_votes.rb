class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, foreign_key: true, null: false
      t.references :votable, polymorphic: true  

      t.timestamps
    end
    add_index :votes, %i[user_id votable_id votable_type], unique: true
  end
end
