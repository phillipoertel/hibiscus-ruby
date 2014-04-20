$LOAD_PATH << 'lib'

require 'hibiscus-ruby'
require 'rspec/core/rake_task'

task :default => "spec:rspec"

namespace "spec" do
  
  RSpec::Core::RakeTask.new(:rspec)
  
  desc "Does mutation testing"
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

  def print_statement_lines(lines)
    lines.reverse.each do |line|
      puts "%s %8s  %s: %s" % [line.date, line.amount, line.type, line.reference.gsub("\n", ";")]
    end
  end

  task :configure_client do
    Hibiscus::Client.config = { password: ENV['PASSWORD'] }
  end

  namespace :account do
    desc "Print all configured accounts"
    task "all" do
      p Hibiscus::Account.new.all
    end
  end
  namespace :statement_line do
    desc "List statement lines for account with ACCOUNT_ID=id (lines for last 30 days)"
    task "latest" do
      lines = Hibiscus::StatementLine.new.latest(ENV['ACCOUNT_ID'], 30)
      print_statement_lines(lines)
    end

    desc "Search for statement lines with STRING=search_term"
    task "search" do
      lines = Hibiscus::StatementLine.new.search(ENV['STRING'])
      print_statement_lines(lines)
    end
  end

  # desc "An example POST request"
  # task post: :configure_client do
  #   data = {
  #     betrag: "0,01",
  #     blz: "38070724", # Bankleitzahl des Gegenkontos
  #     konto: "321487100", # Kontonummer des Gegenkontos
  #     name: "Phillip Oertel", # Inhaber-Name des Gegenkontos
  #     konto_id: "2", # ID des eigenen Kontos
  #     zweck: "Hibiscus Test", # Verwendungszweck Zeile 1
  #   }
  #   p Hibiscus::Transfer.new.create(data)
  # end
end
