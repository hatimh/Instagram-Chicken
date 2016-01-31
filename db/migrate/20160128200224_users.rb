class Users < ActiveRecord::Migration
    def change
      create_table :users do |t|
        t.string :username, :full_name, :profile_picture, :bio, :website
        t.bigint :instagram_user_id
        t.timestamps null: false
      end
      create_table :beats do |t|
        t.string :category, :picture_url
        t.integer :user_id, :likes
        t.timestamps null: false
      end
    end
end
