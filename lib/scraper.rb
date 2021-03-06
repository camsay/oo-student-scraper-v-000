require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = doc.css(".student-card")


    array = students.map  do |student|
      student_info = {:name => student.css("h4").text,
         :location => student.css("p").text,
         :profile_url => student.css('a').attr('href').text}

    end

  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student = doc.css('.profile')
    social = student.css('.social-icon-container a')
    student_quote = student.css('.profile-quote').text
    student_bio = student.css('.bio-block .description-holder').text.strip
    array = []
    profile = {}

    social.each {|link| array << link.attr('href')}

    array.each do |link|
      if link.include?("github")
           profile[:github] = link
      elsif link.include?("linkedin")
           profile[:linkedin] = link
      elsif link.include?("facebook")
           profile[:facebook] = link
      elsif link.include?("twitter")
           profile[:twitter] = link
      else
           profile[:blog] = link
        end
       end

      profile[:profile_quote] = student_quote
      profile[:bio] = student_bio

      profile
  end

end
