require File.expand_path("../lib/hibiscus/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "hibiscus-ruby"
  gem.version       = Hibiscus::VERSION
  gem.platform        = Gem::Platform::RUBY
  gem.authors       = ["Phillip Oertel"]
  gem.summary       = %q{A Ruby client for the HBCI-compliant Hibiscus payment server.}
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_path  = "lib"

  %w(rake httparty).each do |g|
    gem.add_runtime_dependency g
  end

  gem.add_development_dependency 'rspec'
end