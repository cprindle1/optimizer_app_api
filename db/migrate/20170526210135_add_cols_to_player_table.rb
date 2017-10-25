class AddColsToPlayerTable < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :gameTime, :string
    add_column :players, :team, :string
    add_column :players, :opponent, :decimal
  end
end
