class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.integer :external_id
      t.string  :name
      t.text    :description
      t.string  :small_icon_url
      t.integer :publisher_id
      t.decimal :price
      t.string  :version
      t.decimal :average_user_rating
    end

    add_index :apps, :external_id
    add_index :apps, :publisher_id
  end
end
