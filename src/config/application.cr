require "./initializers/*"

require "../types/**"
require "../models/**"
require "../services/**"
require "../controllers/**"

module AccountsService
  if settings.ssl_ca.empty? || settings.ssl_key.empty?
    puts "Running without HTTPS"
    server = ActionController::Server.new(settings.server_port, settings.server_host)
  else
    puts "Running with HTTPS"
    ssl_context = OpenSSL::SSL::Context::Server.new
    ssl_context.certificate_chain= settings.ssl_ca
    ssl_context.private_key= settings.ssl_key

    server = ActionController::Server.new(ssl_context, settings.server_port, settings.server_host)
  end

  terminate = Proc(Signal, Nil).new do |signal|
    puts " > terminating gracefully"
    spawn { server.close }
    signal.ignore
  end
  
  # Detect ctr-c to shutdown gracefully
  # Docker containers use the term signal
  Signal::INT.trap &terminate
  Signal::TERM.trap &terminate
  
  # Check all configurations are correct
  Habitat.raise_if_missing_settings!
  
  server.run do
    puts "Server running on #{server.print_addresses}"
    puts "Running on #{settings.environment} environment"
  end
end
