module Bias

  # Storage adapter manager
  module Storage
    def self.register(name, adapter)
      check_adapter(adapter)
      adapters[name] = adapter
    end

    def self.get_adapter(name)
      adapters[name].tap {|adapter|
        raise UnknownAdapter.new(name) unless adapter
      }
    end

    def self.adapters
      @adapters ||= {}
    end

    def self.check_adapter(adatper)
      true
    end

    def self.reset
      @adapters = nil
    end

    # Base Error
    class Error < StandardError
    end

    # Error thrown for unknown adapters
    class UnknownAdapter < Error
    end

    # Error thrown for incomplete adapters
    class IncompleteAdapter < Error
    end
  end
end
