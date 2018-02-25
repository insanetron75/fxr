class WelcomeController < ApplicationController
  def index
  end

  def convert
    amount = params[:amount]
    date = params[:date]
    base_cur = params[:base_cur]
    con_cur = params[:con_cur]

    rate = ExchangeRate.at(date, base_cur, con_cur)
    converted_amount = (amount.to_i * rate).round(2)
    rate = rate.round(4)

    @message = "#{amount} #{base_cur} = #{converted_amount} #{con_cur} @ #{rate}"

  end
end
