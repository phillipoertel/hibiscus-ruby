module FakeParty
  
  def self.included(other_class)
    other_class.extend(ClassMethods)
  end

  module ClassMethods
    def base_uri(uri)
      puts "Set base_uri to #{uri}"
    end

    def get(url, options = {})
      puts "GET #{url} with options: #{options.inspect}"
      "{}"
    end

    def post(url, options = {})
      puts "POST #{url} with options: #{options.inspect}"
      "{}"
    end
  end

end