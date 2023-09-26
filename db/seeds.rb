# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#!/usr/bin/env ruby
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# !/usr/bin/env ruby

# Load Rails application environment
require_relative '../config/environment'

require 'httparty'
require 'json'
require 'bathing_site'

BathingSite.destroy_all
User.destroy_all

user = User.create!(
  email: "user1@gmail.com",
  password: "123456",
  first_name: "John",
  last_name: "Smith",
  nickname: "jonny"
)

admin = User.create(
  email: "admin@admin.com",
  password: "123456",
  first_name: "Admin",
  last_name: "User",
  nickname: "Admin",
  admin: true
)

api_endpoint = 'http://environment.data.gov.uk/doc/bathing-water.json?_pageSize=200&_view=all&_pageSize=200'

response = HTTParty.get(api_endpoint)

data = JSON.parse(response.body)

data['result']['items'].each do |item|
  site_name = item['label'].first['_value']
  county_name = item['district'].first['label'].first['_value']
  eubwid = item['eubwidNotation']

  web_res_image_url = "https://environment.data.gov.uk/media/image/bathing-water-profile/#{eubwid}_1-webres.jpg"

  BathingSite.create!(
    site_name: site_name,
    region: county_name,
    eubwid: eubwid,
    water_quality: "good",
    user: user,
    web_res_image_url: web_res_image_url
  )

  p "Created #{site_name}, #{county_name} bathing site!"
end

#
# previous api
# csv_path = Rails.root.join('app', 'data', 'site.csv')
# CSV.foreach(csv_path, headers: true) do |row|
#  eubwid = row['EUBWID']
# base_url = 'https://environment.data.gov.uk/id/bathing-water/'
# api_url = "#{base_url}#{eubwid}.json".freeze

 # response = HTTParty.get(api_url)
 # data = response.parsed_response
 # quality = data['result']['primaryTopic']
 # water_quality = quality['latestComplianceAssessment']['complianceClassification']['name']['_value']
 # site_name = data['result']['primaryTopic']['name']['_value']
 # latitude = data['result']['primaryTopic']['samplingPoint']['lat']
 # longitude = data['result']['primaryTopic']['samplingPoint']['long']
 # district = data['result']['primaryTopic']['district'][0]['name']['_value']
