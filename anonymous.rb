#coding: utf-8
require 'vkontakte_api'
require 'csv'
require 'date'

item_ids = File.open("item_ids.txt", "a")

VkontakteApi.configure do |config|
  config.app_id = '6030265'
  config.app_secret = 'Gq0cNyTVLv1g1JKo85qQ'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.api_version = '5.64'
end

@vk = VkontakteApi::Client.new('2f764c762f764c762f764c768b2f2a4fcf22f762f764c76766152af8b40b791c12b1de6')

count_items = 1
i = 0
owner_id = 454810888
offset = 0

CSV.open("anonymous_demo.csv", "a") do |csv_data|
  csv_data << ["Время", "Текст", "Просмотры", "Вложения"]

  9.times do |i|
    posts = []
    100.times do |j|
      n = i * 100 + j
      posts << "#{owner_id}_#{n}"
    end
    posts_str = posts * ','
    @response = @vk.wall.getById(posts: posts_str, copy_history_depth: 0)

    @response.each do |item|
      attachment = nil
      views = nil

      date = DateTime.strptime(item['date'].to_s, '%s').to_s.gsub('T', ' ').split('+').first
      text = item['text']
      views = item['views']['count'] if item['views']
      attachment = item['attachments'].first['type'] if item['attachments']

      csv_data << [date, text, views, attachment]
    end
    sleep 0.15
  end
end