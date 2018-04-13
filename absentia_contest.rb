#coding: utf-8
require 'vkontakte_api'
require 'csv'
require 'date'

# f = File.open("demo2.txt", "a")

VkontakteApi.configure do |config|
  config.app_id = '6030265'
  config.app_secret = 'Gq0cNyTVLv1g1JKo85qQ'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.api_version = '5.64'
end

@vk = VkontakteApi::Client.new('2f764c762f764c762f764c768b2f2a4fcf22f762f764c76766152af8b40b791c12b1de6')

# локальный идентификатор записи
# идентификатор владельца стены
# типы вложений
# ссылка
# ссылка на профиль

i = 0

CSV.open("absentia_demo3.csv", "a") do |csv_data|
  csv_data << ["Локальный идентификатор записи", "Идентификатор владельца стены", "Типы вложений", "Ссылка", "Ссылка на профиль", "Дата"]
  # while true
    @response = @vk.newsfeed.search(q: "#СмотриАмнезию", extended: 0, count: 200, version: '5.12')

    @response['items'].each do |item|
      attachments = ""
      link = "nil"

      post_id = item['id']
      owner_id = item['owner_id']
      user_id = item['from_id']
      unless item['attachments'] == nil
        item['attachments'].each do |att|
          attachments += "#{att['type']}, "
          if att['type'] == 'link'
            link = att['link']['url']
          end
        end
      else
        attachments = "nil"
      end
      date = item['date'].to_s

      i += 1

      csv_data << ["#{post_id}", "#{owner_id}", attachments, link, "https://vk.com/id#{user_id}", "#{DateTime.strptime(date, '%s').to_s.split('T').first}"]

      puts i
    end

    sleep 0.2
  # end
end

