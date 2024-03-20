require "granite/adapter/mysql"
require "micrate"
require "yaml"

config = File.open("src/config/database.yml") {|f| YAML.parse(f)}

db_env = config[AccountsService.settings.environment]? ? config[AccountsService.settings.environment] : config["development"]

connection_url = "mysql://#{db_env["user"]}:#{db_env["password"]}@#{db_env["host"]}:#{db_env["port"].to_s}/#{db_env["db"]}"

Micrate::DB.connection_url = connection_url

Micrate::DB.connect {|db| Micrate.up(db)}

Granite::Connections << Granite::Adapter::Mysql.new(name: "mysql", url: connection_url)