#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'uri'

# Location of ULS dump files
WEEKLY_DUMP_URL =
  'http://wireless.fcc.gov/uls/index.htm?job=transaction&page=weekly'
# Filename to read database selections from
CONFIG_FILENAME = "include-datasets.conf"

# Open our configuration file and determine which datasets to download.
config_file = File.join(File.dirname(__FILE__), CONFIG_FILENAME)
datasets = []
File.open config_file do |file|
  file.each_line do |line|
    if line.match(/^([^#]\S+)/)
      datasets.push $1
    end
  end
end

zips = []
doc = Nokogiri::HTML(open WEEKLY_DUMP_URL)
doc.xpath('//a').each do |link|
  href = link.attributes["href"]
  if href
    if href.value.match(/l_([a-z]+)\.zip$/i)
      if datasets.include? $1
        zips.push href.value
      end
    end
  end
end

print zips.join "\n"
print "\n"
