class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.string :currency
      t.float :rate
      t.string :date

      t.timestamps
    end
  end
end
