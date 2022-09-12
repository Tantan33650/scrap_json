#!/usr/bin/env ruby

require 'open-uri'
require 'csv'
require 'json'


class OmnibookScrapingTool

  def initialize url_to_company_list
    json_list = URI.open url_to_company_list
    @array_of_hash = JSON.parse json_list.read # @array_of_hash.class => Array.
  end

  def save_leaders_infos save_to_path
    CSV.open save_to_path, "w" do |csv|
      csv << ["leader_name", "company_name", "job_title", "phone_number", "email_address", "website"]
      @array_of_hash.each do |company| # company.class => Hash
        company_informations = extract_data_from_company(company)
        company['leaders'].each do |leader| # company['leaders'].class => Hash
          leaders_informations = extract_data_from_leader(leader)
          csv << [
            leaders_informations['leader_name'],
            company_informations['company_name'],
            leaders_informations['job_title'],
            leaders_informations['leader_phone_number'],
            leaders_informations['leader_email'],
            company_informations['company_website']
          ]
        end unless company['leaders'].nil?
      end
    end
  end

  def save_companies_infos save_to_path
    CSV.open save_to_path, "w" do |csv|
      csv << ["company_name", "company_address", "company_phone_number", "company_email_address", "company_website"]
      @array_of_hash.each do |company|
        company_informations = extract_data_from_company(company)
        csv << [
          company_informations['company_name'],
          company_informations['company_address'],
          company_informations['company_phone_number'],
          company_informations['company_email_address'],
          company_informations['company_website']
        ]
      end
    end
  end

  def size_of_list
    @array_of_hash.size
  end

  private

  def extract_data_from_company(c)
    company_name          = c['h'].nil? ? 'Not specified' : c['h']
    company_website       = c['v'].nil? ? 'Not specified' : c['v']
    company_address       = "#{c["j"]} #{c["k"]} #{c["m"]} #{c["n"]} #{c["o"]} #{c["p"]} #{c["q"]}".strip
    company_phone_number  = c["r"]
    company_email_address = c["u"]
    return {
      'company_name' => company_name,
      'company_website' => company_website,
      'company_address' => company_address,
      'company_phone_number' => company_phone_number,
      'company_email_address' => company_email_address
    }
  end

  def extract_data_from_leader(leader)
    leader_name         = "#{leader['du']} #{leader['dv']}"
    job_title           = leader['dw'].nil? ? 'Not specified' : leader['dr']
    leader_phone_number = leader['dx'].nil? ? 'Not specified' : leader['dx']
    leader_email        = leader['dy'].nil? ? 'Not specified' : leader['dy']
    return {
      'leader_name'         => leader_name,
      'job_title'           => job_title,
      'leader_phone_number' => leader_phone_number,
      'leader_email'        => leader_email
    }
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
    omnibook_scraping_tool.save_leaders_infos 'omnibook_leaders.csv'
    omnibook_scraping_tool.save_companies_infos 'omnibook_companies.csv'
    end_time = Time.now
    puts " done!"
    puts " --> Saved #{omnibook_scraping_tool.size_of_list} elements on '../assets/omnibook_leaders.csv'."
    puts " --> Saved #{omnibook_scraping_tool.size_of_list} elements on '../assets/omnibook_companies.csv'."
    puts "     (#{(end_time - start_time).round(3)}ms)"
    puts
  end

end

OmnibookScrapingToolApp.new.execute