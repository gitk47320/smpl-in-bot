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
      # message = {
      #     type: "location",
      #     title: "検索結果",
      #     address: address,
      # }
      columns = []
      while i < shops['ResultInfo']['Count']
        columns << [
          {
            text: shops['Feature'][i]['Name'], 
            actions: [
              {
                type: "message", 
                label: "アクション", 
                text: "アクション"
              }
            ]
          }
        ]
        i = i + 1
      end
      p columns

      message = {
          type: "template",
          altText: "this is a carousel template",
          template: {
            type: "carousel",
            actions: [],
            columns: columns
            # columns: [
            #   {
            #       # {
            #       #   type: "message",
            #       #   label: "アクション#{i+1}",
            #       #   text: "アクション#{i+1}"
            #       # }
            #     ]
            #   }
            # ]
          }
        }
      
      client.reply_message(event['replyToken'], message)
      end
    ######################################
    ### テンプレートメッセージを使ったbot ###
    ######################################
    # events.each do |event|
    #   p event.message['text']
    #   latlon  = getlatlon(event.message['text'])
    #   address = getAddress(latlon[1], latlon[0])
    #   message = {
    #       type: "location",
    #       title: "検索結果",
    #       address: address,
    #       latitude: latlon[1],
    #       longitude: latlon[0]
    #   }
    #   client.reply_message(event['replyToken'], message)
    # end

    head :ok
  end
end
