#!/usr/bin/env ruby

require 'open-uri'
require 'csv'
require 'json'
require 'colorize'


class OmnibookScrapingTool

  def initialize url_to_company_list
    json_list = URI.open url_to_company_list
    @columns_names_array = ["company_name", "address", "phone_number", "email_address", "website"]
    @array_of_hash = JSON.parse json_list.read # @array_of_hash.class => Array.
  end

  def save_info_to save_to_path
    CSV.open save_to_path, "w" do |csv|
      csv << @columns_names_array
      @array_of_hash.each do |x| # x.class => Hash
        csv << build_company_line(x)
      end
    end
  end

  def size_of_list
    @array_of_hash.size
  end

  def display_line_from_list x
    line = @array_of_hash[x]
    puts " Company name:   " + "#{line["h"]}"
    puts " Address:        " + "#{line["j"]} #{line["k"]} #{line["m"]} #{line["n"]} #{line["o"]} #{line["p"]} #{line["q"]}".strip
    puts " Phone number:   " + "#{line["r"]}"
    puts " Email address:  " + "#{line["u"]}" 
    puts " Webstide:       " + "#{line["v"]}"
  end

  private

  def build_company_line x
    company_name  = x["h"]
    address       = "#{x["j"]} #{x["k"]} #{x["m"]} #{x["n"]} #{x["o"]} #{x["p"]} #{x["q"]}".strip
    phone_number  = x["r"]
    email_address = x["u"]
    website       = x["v"]
    return        [company_name, address, phone_number, email_address, website]
  end

end

class OmnibookScrapingToolApp

  def initialize
    @url_to_company_list = 'https://7ae88baa-e4e4-45ff-bd85-4564a5c70346.omnibook.com/rev/37/resources/data.json'
  end

  def execute
    print "\n --> Scraping from #{@url_to_company_list}..."
    start_time = Time.now
    omnibook_scraping_tool = OmnibookScrapingTool.new(@url_to_company_list)
    omnibook_scraping_tool.save_info_to '../assests/scrap.csv'
    end_time = Time.now
    puts " done!"
    puts " --> Saved #{omnibook_scraping_tool.size_of_list} elements on '../assests/scrap.csv'."
    puts "     (#{(end_time - start_time).round(3)}ms)"
    puts "\n" + " First element of the list... ".colorize(background: :white, color: :black)
    omnibook_scraping_tool.display_line_from_list(1)
    puts "\n" + " Last element of the list... ".colorize(background: :white, color: :black)
    omnibook_scraping_tool.display_line_from_list(omnibook_scraping_tool.size_of_list - 1)
    puts "\nPress enter to quit"
    gets
  end

end

system 'cls'; system 'clear'
OmnibookScrapingToolApp.new.execute