require 'net/http'
require "rexml/document"

class Rate < ApplicationRecord

  def self.at(date, base_cur, con_cur)
    # Convert base_cur down to 1
    base_rate = Rate.where(currency: base_cur.upcase, date: date).take
    con_rate = Rate.where(currency: con_cur, date:date).take

    # The rate between the base and con is the con rate / base rate
    return (con_rate.rate / base_rate.rate)
  end

  def self.update_rates
    puts "Updating Rates..."

    puts "Getting Rates..."
    rates_hash = Rate.get_rates
    puts "Done!"

    puts "Saving Rates...."
    Rate.save_rates(rates_hash)
    puts "Done!"

    puts "Update Complete"
  end

  def self.get_rates
    # First get the xml from the URL
    url = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'
    xml_string = Net::HTTP.get_response(URI.parse(url)).body

    # Convert to hash and retrieve useful parts
    xml_hash = Hash.from_xml(xml_string)
    return xml_hash["Envelope"]["Cube"]["Cube"]
  end

  def self.save_rates(rates_hash)
    # Loop through each date and retrieve the date string
    rates_hash.each do |day|
      date = day["time"]

      # Loop through each currency and get the values
      day["Cube"].each do |value|
        currency = value["currency"]
        rate = value["rate"]

        # Chech if the rate exists, if not create it
        Rate.check_and_create_rate(date, currency, rate)
      end
    end
  end

  def self.check_and_create_rate(date, cur, rate)
    # Try and find an existing rate row
    rate_object = Rate.where(currency: cur, date: date)
    unless (!rate_object.empty?)
      # Create rate and return
      Rate.create(currency: cur, rate: rate, date: date)
      return true
    else
      # Rate already exists, return
      return true
    end    
  end
end
