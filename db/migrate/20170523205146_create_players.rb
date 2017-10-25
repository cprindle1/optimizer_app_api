class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :Position
      t.string :Name
      t.string :Salary
      t.string :teamAbbrev

      t.timestamps
    end
  end
end
