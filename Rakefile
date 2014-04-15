$LOAD_PATH << 'lib'

require 'hibiscus/account'
require 'hibiscus/statement_lines'
require 'hibiscus/jobs'
require 'hibiscus/transfer'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :configure_client do
  Hibiscus::Client.instance.config = { 
    username: ENV['USERNAME'] || 'admin',
    password: ENV['PASSWORD'],
    verify:   false,
    base_uri: 'https://localhost:8080/webadmin/rest/hibiscus'
  }
end

task test_get: :configure_client do
  #p Hibiscus::Account.new.all
  #p Hibiscus::Jobs.new.pending
  #p Hibiscus::Transfer.new.delete(2) # interne überweisungs-id verwenden
  #p Hibiscus::Transfer.new.pending
  #p Hibiscus::StatementLines.new.search('paypal')
  p Hibiscus::StatementLines.new.latest(2, 5)
end

task test_post: :configure_client do
  data = {
    betrag: "0,01",
    blz: "38070724", # Bankleitzahl des Gegenkontos
    konto: "321487100", # Kontonummer des Gegenkontos
    name: "Phillip Oertel", # Inhaber-Name des Gegenkontos
    konto_id: "2", # ID des eigenen Kontos
    zweck: "Hibiscus Test", # Verwendungszweck Zeile 1
  }
  p Hibiscus::Transfer.new.create(data)
end