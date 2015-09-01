class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :external_id
      t.string  :name
    end

    add_index :categories, :external_id
  end
end
