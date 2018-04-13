#coding: utf-8
require 'vkontakte_api'
require 'csv'
require 'date'

item_ids = File.open("ru_spike_item_ids.txt", "a")

VkontakteApi.configure do |config|
  config.app_id = '6030265'
  config.app_secret = 'Gq0cNyTVLv1g1JKo85qQ'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.api_version = '5.64'
end

@vk = VkontakteApi::Client.new('2f764c762f764c762f764c768b2f2a4fcf22f762f764c76766152af8b40b791c12b1de6')

count_items = 1
i = 0
owner_id = -140831527
offset = 0

while i < count_items
  @response = @vk.wall.get(owner_id: owner_id, offset: offset, count: 100)
  i += 100
  count_items = @response['count'].to_i
  offset = i

  @response['items'].each do |item|
    item_ids.write("#{item['id']}, #{item['date']}\n")
  end

  sleep 0.2
end

item_ids.close
item_ids = File.open("ru_spike_item_ids.txt", "r")

CSV.open("ru_spike_demo.csv", "a") do |csv_data|
  csv_data << ["Дата", "Ссылка на пост", "Ссылка на пользователя"]

  item_ids.each_line do |line|
    date = line.split(', ').last
    item_id = line.split(', ').first

    @response = @vk.likes.getList(type: 'post', owner_id: owner_id, item_id: item_id.to_i, count: 1000)

    @response['items'].each do |id|
      csv_data << ["#{DateTime.strptime(date, '%s').to_s.split('T').first}", "https://vk.com/ru_spike?w=wall#{owner_id}_#{item_id}", "https://vk.com/id#{id}"]
    end

    sleep 0.2
  end
end