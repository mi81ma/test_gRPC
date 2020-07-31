require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Client
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

## config > application に、以下ののコードを追加する
config.paths.add Rails.root.join(
  'app',
  'gen',
  'api',
  'pancake',
  'maker'
).to_s,
eager_load: true

## Ruby on Rails6で導入されたZeitwerkの影響を回避するため次のコードを利用する
## ただし、Rails6の趣旨としては、
## 本来は Zeitwerk のカスタム Inflater を追加するか、Zeitwerk の規約に沿った生成を行うプラグインを書くのが望ましい。
config.load_defaults 5.2
config.autoloader = :classic