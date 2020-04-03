require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = doc.css(".student-card")
    student_profiles = []
    students.each do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a").first["href"]
      student_profiles << student_hash
    end
    student_profiles
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    profile_info = {}
    profile.css("div.social-icon-container a").each do |link|
      text = link["href"]
      if text.include? "twitter"
        profile_info[:twitter] = text
      elsif text.include? "linkedin"
        profile_info[:linkedin] = text
      elsif text.include? "github"
        profile_info[:github] = text
      else 
        profile_info[:blog] = text
      end
    end
    profile_info[:profile_quote] = profile.css("div.profile-quote").text
    profile_info[:bio] = profile.css("div.description-holder p").text.strip
    profile_info
  end

end

