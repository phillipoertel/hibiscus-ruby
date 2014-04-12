require_relative 'lib/hibiscus_resource'
require_relative 'lib/transfer'
require_relative 'lib/jobs'
require_relative 'lib/account'
require_relative 'lib/statement_lines'

task :default do
  new_booking = StatementLines.new(ENV['PASSWORD']).search("paypal")
  
end

task :book do
  data = {
    betrag: "0,01",
    blz: "123", # Bankleitzahl des Gegenkontos
    konto: "456", # Kontonummer des Gegenkontos
    name: "Phillip Oertel", # Inhaber-Name des Gegenkontos
    konto_id: "2", # ID des eigenen Kontos
    zweck: "Hibiscus Test", # Verwendungszweck Zeile 1
  }
  #puts @client.post(data)
end