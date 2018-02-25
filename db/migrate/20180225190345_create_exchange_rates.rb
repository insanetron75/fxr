class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string :currency
      t.float :rate
      t.string :date

      t.timestamps
    end
  end
end
