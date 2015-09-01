class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :external_id
      t.string  :name
    end
  end
end
