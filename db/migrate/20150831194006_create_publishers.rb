class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
      t.string  :external_id
      t.string  :name
    end

    add_index :publishers, :external_id
  end
end
