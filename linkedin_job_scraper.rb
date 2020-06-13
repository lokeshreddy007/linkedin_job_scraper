require 'nokogiri'
require 'httparty'
require 'byebug'
require 'colorize'

String.colors  

def scraper
    url = "https://www.linkedin.com/jobs/search?keywords=#{ARGV[0]}&location=#{ARGV[1]}"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    puts ""
    puts ""
    # Getting Result 1,000+ Results for "React in Secunderābād, Telangana, India"(48 new)
    total_jobs = parsed_page.css('span.results-context-header__job-count').text
    query_result_info = parsed_page.css('span.results-context-header__query-search').text
    new_jobs = parsed_page.css('span.results-context-header__new-jobs').text
    puts total_jobs.colorize(:green) + ' ' + query_result_info.colorize(:green) + ' ' + new_jobs.colorize(:green)
    puts ""
    puts ""
    
    # Getting Job Info and storing in a Array
    jobs = Array.new
    job_listings = parsed_page.xpath("//li[@class='result-card job-result-card result-card--with-hover-state']")
    job_listings.each do |job_listing|
        job = {
             title: job_listing.css('h3').text,
            company:job_listing.css('h4').text,
            location:job_listing.css('span.job-result-card__location').text,
            url: job_listing.css('a')[0].attributes['href'].value
        }
        jobs << job
        puts "#{job[:title]} "
        puts "Company: #{job[:company]}"
        puts "Location: #{job[:location]}"
        puts ""
        puts job[:url].colorize(:light_blue )
        puts ""
        puts ""
    end
    # byebug
end

scraper