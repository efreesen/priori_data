class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :category_id
      t.string  :monetization
      t.integer :rank
      t.integer :app_id
      t.integer :publisher_id
    end
  end
end
