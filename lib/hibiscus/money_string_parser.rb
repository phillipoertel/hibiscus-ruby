# stolen from my outbanker gem
module Hibiscus
  class MoneyStringParser
    def self.to_cents(string)
      matches = string.match(/(?<separator>\.|\,)(?<cents>[0-9]{1,2})\Z/)
      if !matches
        string.to_i * 100
      elsif matches[:cents].length == 1
        string.gsub(matches[:separator], '').to_i * 10
      elsif matches[:cents].length == 2
        string.gsub(matches[:separator], '').to_i
      end
    end
  end
end