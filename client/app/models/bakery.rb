# frozen_string_literal:true

require Rails.root.join('app', 'gen', 'api', 'pancake', 'maker', 'pancake_pb') 
require Rails.root.join('app', 'gen', 'api', 'pancake', 'maker', 'pancake_services_pb')

require 'grpc'

# Set grpc logger for debug / Remove this later
module RubyLogger
  def logger
    LOGGER
  end

  LOGGER = Logger.new(STDOUT)
  LOGGER.level = :debug
end

module GRPC
  extend RubyLogger
end

class Bakery
  include ActiveModel::Model

  # パンケーキのメニュー 
  class Menu
    CLASSIC = "classic"
    BANANA_AND_WHIP = "banana_and_whip"
    BACON_AND_CHEESE = "bacon_and_cheese"
    MIX_BERRY = "mix_berry"
    BAKED_MARSHMALLOW = "baked_mashmallow"
    SPICY_CURRY = "spicy_curry"
  end # class内class end
  
  # 1. パンケーキを焼きます
  def self.bake_pancake(menu)
    ## bake_pancake は、パンケーキを焼くAPIにリクエストを送るメソッドです。
    ### このbake_pancakeメソッドでは、次の3つを行います
    ### 1. はじめに Pancake::Baker::BakeRequest のオブジェクトを作成します
    ### 2. 次に Stub の bake メソッドを呼び出し、
    ### 3. 最後に gRPC サーバーから API の返り値として返された Pan- cake::Baker::BakeResponse を Hash に変換しています。


    ### 1. 
    req = Pancake::Maker::BakeRequest.new({ 
      menu: pb_menu(menu),
    })
    
    ### 2. Stubのbakeメソッドの呼び出し
    # bake_pancakeメソッドの引数であるmenuが不正な場合、GRPC::InvalidArgumentが返ってきます。
    res = stub.bake(req)

    ### 3. ハッシュへ変換
    {
        chef_name:        res.pancake.chef_name,
        menu:             res.pancake.menu,
        technical_score:  res.pancake.technical_score,
        create_time:      res.pancake.create_time,
    }

  end # def end

  # レポートを書きます
  def self.report
    res = stub.report(Pancake::Maker::ReportRequest.new())

    res.report.bake_counts.map {|r| [r.menu, r.count]}.to_h
    ## (memo: .to_hは、配列をハッシュに変換するメソッド)
  end

  # メニューをProtocol Buffers用に変換します
  def self.pb_menu(menu)
    case menu
    when Menu::CLASSIC
        :CLASSIC
    when Menu::BANANA_AND_WHIP
        :BANANA_AND_WHIP
    when Menu::BACON_AND_CHEESE
        :BACON_AND_CHEESE
    when Menu::MIX_BERRY
        :MIX_BERRY
    when Menu::BAKED_MARSHMALLOW
        :BAKED_MARSHMALLOW
    when Menu::SPICY_CURRY
        :SPICY_CURRY
    else
        raise "unknown menu: #{munu}"
    end # case end
  end # def end


  ##### gRPC のサービスに接続する 2つのメソッド#####
  ## 01 gRPC のサービスに接続するメソッド
  def self.config_dsn
      "127.0.0.1:50051"
  end
  
  ## 02 gRPC のサービスに接続するメソッド
  def self.stub
      Pancake::Maker::PancakeBakerService::Stub.new(config_dsn,   :this_channel_is_insecure)
      # Stub.new で gRPC のサービスに接続できるクラスメソッドを定義する
      # 引数とし て接続情報を渡しています。
      # 接続情報は接続先の IP アドレスとポート番号です。本来であれば config ディレクトリの中で管理 すべきですが、今回は簡略化しました。gRPC では TLS を使って安全に通信することもできますが、 今回は:this_channel_is_insecure を指定して、平文のままで通信しています。
  end

  def self.stub
    # サーバー側が応答しない場合にタイムアウトするように設定しておきます。
    Pancake::Maker::PancakeBakerService::Stub.new(
        config_dsn,
        :this_channel_is_insecure,
        timeout: 10, ## 10 秒でタイムアウトするように設定
    )
  end
end # class end