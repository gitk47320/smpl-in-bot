class SamplelinebotController < ApplicationController
# develop for linebot
  require 'line/bot'  # gem 'line-bot-api'
  include Common

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  # line bot利用のためのキー設定
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read
    # リクエストの妥当性検証。lineから送られてきたメッセージかどうか
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    
    #####################
    ### APIを使ったbot ###
    #####################
    events.each do |event|
      shops = getShops(event.message['latitude'], event.message['longitude'])
      columns = []
      i = 0
      while i < shops['ResultInfo']['Count']
        latlon = shops['Feature'][i]['Geometry']['Coordinates'].split(",")
        columns.push(
          {
            text: shops['Feature'][i]['Name'], 
            actions: [
              {
                type: "uri", 
                label: "地図を表示", 
                uri: "https://www.google.co.jp/maps/@#{latlon[1]},#{latlon[0]},20z"
              }
            ]
          }
        )
        i = i + 1
      end
      
      message = {
          type: "template",
          altText: "this is a carousel template",
          template: {
            type: "carousel",
            actions: [],
            columns: columns
          }
        }
      
      client.reply_message(event['replyToken'], message)
      end
    
    head :ok
  end
end
