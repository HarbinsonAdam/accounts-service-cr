require "habitat"
require "lucky_env"
require "action-controller"
require "action-controller/server"

module AccountsService
  Habitat.create do
    setting environment : String = "local_development", example: "local_development"
    setting server_host : String
    setting server_port : Int32
    setting ssl_ca : String
    setting ssl_key : String
  end

  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}

  begin
    LuckyEnv.load("src/config/.env")
  rescue LuckyEnv::MissingFileError
    # Handle the case where LuckyEnv cannot load the file
    puts "Could not load environment file. Using default values."
  end

  settings.server_host = ENV["SERVER_HOST"]? || "127.0.0.1"
  settings.server_port = (ENV["SERVER_PORT"]? || 3008).to_i32

  settings.ssl_ca = ENV["SSL_CA"]? || ""
  settings.ssl_key = ENV["SSL_KEY"]? || ""

  FILTER_PARAMS = ["password", "Authorization"]
  LOG_HEADERS = ["X-Request-ID"]

  ActionController::Server.before(
    ActionController::ErrorHandler.new(settings.environment == "production", LOG_HEADERS),
    ActionController::LogHandler.new(FILTER_PARAMS),
    HTTP::CompressHandler.new,
  )

  ActionController::Session.configure do |settings|
    settings.key = Random::Secure.urlsafe_base64(48)
    settings.secret = Random::Secure.urlsafe_base64(48)
    # HTTPS only:
    settings.secure = AccountsService.settings.environment != "local_development"
  end
end