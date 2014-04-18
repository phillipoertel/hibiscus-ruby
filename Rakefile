$LOAD_PATH << 'lib'

require 'hibiscus/account'
require 'hibiscus/statement_lines'
require 'hibiscus/jobs'
require 'hibiscus/transfer'

require 'rspec/core/rake_task'

task :default => "spec:rspec"

namespace "spec" do
  
  RSpec::Core::RakeTask.new(:rspec)
  
  desc "does mutation testing for selected classes"
  task :mutation do
    # find the classes we have specs for
    classes_with_specs = Dir.glob('spec/hibiscus/*_spec.rb')
    # create a hash of the form {'Ruby class name' => 'class file name'}
    classes_and_specs = classes_with_specs.inject({}) do |hash, spec_path| 
      klass            = spec_path.match(%r{/([a-z]+)_spec.rb})[1]
      klass_constant = "Hibiscus::#{klass.capitalize}"
      klass_path     = spec_path.sub(%r{\Aspec/}, '').sub('_spec.rb', '.rb')
      hash[klass_constant] = klass_path
      hash
    end
    cmd_template = "bundle exec mutant --include lib --use rspec --fail-fast --require SPEC CLASS"
    classes_and_specs.each do |klass, spec| 
      cmd = cmd_template.sub("CLASS", klass).sub("SPEC", spec)
      system(cmd)
    end
  end

end

namespace :examples do

  task :configure_client do
    Hibiscus::Client.instance.config = { 
      username: ENV['USERNAME'] || 'admin',
      password: ENV['PASSWORD'],
      verify:   false,
      base_uri: 'https://localhost:8080/webadmin/rest/hibiscus'
    }
  end

  desc "An example GET request"
  task get: :configure_client do
    #p Hibiscus::Account.new.all
    #p Hibiscus::Jobs.new.pending
    #p Hibiscus::Transfer.new.delete(2) # interne überweisungs-id verwenden
    #p Hibiscus::Transfer.new.pending
    #p Hibiscus::StatementLines.new.search('paypal')
    p Hibiscus::StatementLines.new.latest(2, 5)
  end

  desc "An example POST request"
  task post: :configure_client do
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
end
