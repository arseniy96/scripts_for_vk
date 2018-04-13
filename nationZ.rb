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
group_id = 23801213

CSV.open("nationZ_demo.csv", "a") do |csv_data|
  csv_data << ["Локальный идентификатор записи", "Идентификатор владельца стены", "Типы вложений", "Ссылка", "Ссылка на профиль", "Дата", "Участник группы", "Город"]
  # while true
  @response = @vk.newsfeed.search(q: "#смотринацияz", extended: 0, count: 200, version: '5.12')

  sleep 1

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
    # Является ли пользователь членом группы
    if owner_id > 0
      @response_for_member = @vk.groups.isMember(group_id: group_id, user_id: owner_id)
      @response_for_city = @vk.users.get(user_ids: owner_id, fields: 'city')
      if @response_for_member == 1
        member = "Да"
      else
        member = "Нет"
      end
      if @response_for_city.first['city']
        city = @response_for_city.first['city']['title']
      else
        city = "Не указан"
      end
    end

    i += 1

    csv_data << ["#{post_id}", "#{owner_id}", attachments, link, "https://vk.com/id#{user_id}", "#{DateTime.strptime(date, '%s').to_s.split('T').first}", member, city]

    puts i

    sleep 0.3
  end

  # end
end

