class AddProjectionColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :Projection, :decimal
    add_column :players, :CurrentWeek, :integer

  end
end
