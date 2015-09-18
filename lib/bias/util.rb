module Bias

  # Utilities used throughout Bias
  module Util
    def self.separator
      '-+|+-'
    end

    def self.normalize(*strings)
      return strings.map {|string| string.to_s.downcase} if strings.length > 1
      strings.first.to_s.downcase
    end

    def self.blank?(string)
      string.to_s.strip == ''
    end
  end
end
