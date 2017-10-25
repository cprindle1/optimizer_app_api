class UpdateSchema < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :Projection, :projection
  end
end
