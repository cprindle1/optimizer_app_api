class UpdatePlayerTable < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :GameInfo, :string
    add_column :players, :AvgPointsPerGame, :string

  end
end
