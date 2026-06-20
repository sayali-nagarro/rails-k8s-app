class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :sku, null: false
      t.integer :stock_quantity, default: 0
      t.string :category
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :category
    add_index :products, :status
  end
end
