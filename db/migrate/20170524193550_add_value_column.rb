class AddValueColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :Value, :decimal

  end
end
