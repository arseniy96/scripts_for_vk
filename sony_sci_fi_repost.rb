#coding: utf-8
require 'vkontakte_api'
require 'csv'

items = File.open("items.txt", "a")

VkontakteApi.configure do |config|
  config.app_id = '6030265'
  config.app_secret = 'Gq0cNyTVLv1g1JKo85qQ'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.api_version = '5.64'
end

@vk = VkontakteApi::Client.new('2f764c762f764c762f764c768b2f2a4fcf22f762f764c76766152af8b40b791c12b1de6')

count_reposts = 89
owner_id = -23801213
post_id = 20403

@response = @vk.wall.getReposts(owner_id: owner_id, post_id: post_id, count: count_reposts)

@response['items'].each do |item|
  puts item['from_id']
  items.write("#{item['id']}, #{item['from_id']}\n")
end

# items.close
# items = File.open("items.txt", "r")
#
# CSV.open("sony_sci_fi_repost_demo.csv", "a") do |csv_data|
#   csv_data << ["Ссылка на пост", "Пользователь/группа", "id", "Город"]
#
#   items.each_line do |line|
#     city = nil
#     post_id = line.split(', ').first
#     user_id = line.split(', ').last.strip
#     if user_id.to_i > 0
#       type = 'Пользователь'
#       @response = @vk.users.get(user_ids: user_id, fields: 'city', name_case: 'Nom')
#       city = @response.first['city']['title'] if @response.first['city']
#     else
#       type = 'Группа'
#     end
#
#     csv_data << ["https://vk.com/wall#{user_id}_#{post_id}", type, user_id, city]
#
#     sleep 0.2
#   end
# end