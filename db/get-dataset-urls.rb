#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'uri'

zips = []
doc = Nokogiri::HTML(
  open 'http://wireless.fcc.gov/uls/index.htm?job=transaction&page=weekly')
doc.xpath('//a').each do |link|
  href = link.attributes["href"]
  if href
    if href.value.match /l_([a-z])+\.zip$/i
      zips.push href.value
    end
  end
end

print zips.join "\n"
