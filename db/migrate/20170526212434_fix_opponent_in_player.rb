class FixOpponentInPlayer < ActiveRecord::Migration[5.0]
  def change
    change_column :players, :opponent, :string
  end
end
