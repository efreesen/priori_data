class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.integer :external_id
      t.string  :name
      t.text    :description
      t.string  :small_icon_url
      t.integer :publisher_id
      t.float :price, default: 0.0
      t.string  :version
      t.float :average_user_rating, default: 0.0
    end

    add_index :apps, :external_id
    add_index :apps, :publisher_id
  end
end
