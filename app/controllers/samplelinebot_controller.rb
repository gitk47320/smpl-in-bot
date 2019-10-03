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

    #############
    # オウム返し #
    #############
    # events.each do |event|
    #   message = {
    #     type: 'text',
    #     text: event.message['text'] 
    #   }
    #   client.reply_message(event['replyToken'], message)
    # end

    ####################################################
    ### オウム返しbot応用（送信内容によって返信を変える）###
    ####################################################
    # parse結果に応じてレスポンスを生成する。
    # line botの送信内容のメイン処理
    # events.each do |event|
    #   case event.message['text']
    #   when 'おはよう' then
    #     greeting = 'おはようございます'
    #   when 'おやすみ' then
    #     greeting = 'おやすみなさい'
    #   else
    #     greeting = 'こんにちわ'
    #   end
    #   message = {
    #     type: 'text',
    #     text: greeting
    #   }
    #   client.reply_message(event['replyToken'], message)
    # end

    ##################################
    ### オウム返しbot応用（演習問題）###
    ##################################
    # parse結果に応じてレスポンスを生成する。
    # line botの送信内容のメイン処理
    # events.each do |event|
    #   case event.message['type']
    #   when 'sticker' then
    #   message = {
    #     type: 'sticker',
    #     packageId: '11537',
    #     stickerId: '52002734'
    #   }
    #   else
    #   message = {
    #     type: 'text',
    #     text: 'こんにちわ'
    #   }
    #   end
    #   client.reply_message(event['replyToken'], message)
    # end

    #####################
    ### APIを使ったbot ###
    #####################
    events.each_with_index do |event,i|
      # p event.message['latitude']
      #latlon  = getlatlon(event.message['text'])
      shops = getShops(event.message['latitude'], event.message['longitude'])
      columns = []
      i = 0
      while i < shops['ResultInfo']['Count']
        columns.push(
          {
            text: shops['Feature'][i]['Name'], 
            actions: [
              {
                type: "uri", 
                label: "地図を表示", 
                uri: "https://www.google.co.jp/maps/@#{shops['Feature'][i]['Geometry']['Coordinates']}"
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
