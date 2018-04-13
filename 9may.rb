#coding: utf-8
require 'vkontakte_api'
require 'csv'

# f = File.open("demo2.txt", "a")

VkontakteApi.configure do |config|
  config.app_id = '6030265'
  config.app_secret = 'Gq0cNyTVLv1g1JKo85qQ'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.api_version = '5.64'
end

@vk = VkontakteApi::Client.new('2f764c762f764c762f764c768b2f2a4fcf22f762f764c76766152af8b40b791c12b1de6')

# дата поста,
# время поста,
# текст поста,
# id пользователя который разместил,
# кол-во лайков,
# просмотры поста,
# тип прикреплённого контента,
# геоданные

end_date = 1494323130 #09.05.2017, 12:45:30 (мск) #10 мая 08:00 (мск) 1494325140
i=0

CSV.open("9may_demo.csv", "a") do |csv_data|
  CSV.open("9may_users.csv", "a") do |csv_users|
    while end_date > 1494259200 #08 мая 19:00 (мск)
      @response = @vk.newsfeed.search(q: "#9мая", extended: 0, count: 200, start_time: 1494255600, end_time: end_date)

      @response['items'].each do |item|
        date = Time.at(item['date']).to_s.split(' ')[0]
        time = Time.at(item['date']).to_s.split(' ')[1]
        text = (item['text'])
        user_id = item['from_id']
        likes = item['likes']['count']
        reposts = item['reposts']['count']
        views = item['views']['count'] if item['views'] != nil
        unless item['geo'] == nil
          geo = item['geo']['coordinates']
        else
          geo = "nil"
        end
        unless item['attachments'] == nil
          type_content = item['attachments'].first['type']
        else
          type_content = "nil"
        end

        i += 1

        if user_id.to_i > 0
=begin
          @user = @vk.users.get(user_ids: user_id, fields: ('sex,city,bdate,counters'), name_case: "Nom")

          # id пользователя,
          # кол-во друзей,
          # город,
          # возраст,
          # пол

          friends = @vk.friends.get(user_id: user_id)['count']
          unless @user.first['city'] == nil
            city = @user.first['city']['title']
          else
            city = "nil"
          end
          if @user.first['bdate'] != nil && @user.first['bdate'].to_s.split(".").size == 3
            age = 2017 - @user.first['bdate'].to_s.split(".")[2].to_i
          else
            age = "nil"
          end
          if @user.first['sex'] == 2
            sex = "М"
          else
            sex = "Ж"
          end

          csv_users << ["#{user_id}, #{friends}, #{city}, #{age}, #{sex}"]
=end
          # f.write("\"#{date}\", \"#{time}\", \"#{text}\", \"#{user_id}\", \"#{likes}\", \"#{reposts}\", \"#{views}\", \"#{type_content}\", \"#{geo}\"\n")
          csv_data << ["#{date}", "#{time}", "#{text}", "#{user_id}", "#{likes}", "#{reposts}", "#{views}", "#{type_content}", "#{geo}"]
        else
          csv_data << ["#{date}", "#{time}", "#{text}", "#{user_id}", "#{likes}", "#{reposts}", "#{views}", "#{type_content}", "#{geo}"]
        end

        end_date = item['date']

        puts i
        puts Time.at(end_date)
      end
      end_date += 1

      sleep 0.2
    end
  end
end

# while end_date > 1494406800 #1494234000 #8 мая 12:00 (мск)
#   7.times do
#
#     if start_from == 0
#       @response = @vk.newsfeed.search(q: "#9мая", extended: 1, count: 125, start_time: 1494230400, end_time: end_date)
#     else
#       @response = @vk.newsfeed.search(q: "#9мая", extended: 1, count: 125, start_time: 1494230400, end_time: end_date, start_from: start_from)
#     end
#
#     @response['items'].each do |item|
#       date = Time.at(item['date']).to_s.split(' ')[0]
#       time = Time.at(item['date']).to_s.split(' ')[1]
#       text = item['text']
#       user_id = item['from_id']
#       likes = item['likes']['count']
#
#       # start_from = @response['next_from']
#
#       i += 1
#       puts "#{date} #{time}"
#
#       # if user_id > 0
#       #   puts "date = #{date}, time = #{time}, text = #{text}, user_id = #{user_id}, likes = #{likes}"
#       # else
#       #   puts "date = #{date}, time = #{time}, text = #{text}, group_id = #{user_id.abs}, likes = #{likes}"
#       # end
#
#       end_date = item['date']
#     end
#
#     puts i
#
#   end
#
#   start_from = 0
#   sleep 5
# end
