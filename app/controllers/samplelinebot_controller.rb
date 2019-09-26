class SamplelinebotController < ApplicationController
# develop for linebot
  require 'line/bot'  # gem 'line-bot-api'

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

    # リクエスト内容をparseする
    events = client.parse_events_from(body)

    # parse結果に応じてレスポンスを生成する。
    # line botの送信内容のメイン処理
    events.each do |event|
      if event.message.type == 'message'
        message = {
          type: 'text',
          text: event.message['text']
        }
      else
        message = {
          type: 'text',
          text: '文字以外を送らないでください'
        }
      end
      client.reply_message(event['replyToken'], message)
    end

    # events.each do |event|
    #   case event
    #   when Line::Bot::Event::Message
    #     case event.type
    #     when Line::Bot::Event::MessageType::Text
    #       if event.message.text == 'おはよう' then
    #         message = {
    #           type: 'text',
    #           text: event.message['text']
    #         }
    #       end
    #     client.reply_message(event['replyToken'], message)
    #     end
    #   end
    # end
    head :ok
  end
end
