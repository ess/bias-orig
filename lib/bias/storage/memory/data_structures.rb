module Bias
  module Storage
    class Memory

      # Memory Data structures
      module DataStructures

        def categories
          @categories ||= []
        end

        private

        def words
          @words ||= []
        end

        def categorizations
          @categorizations ||= {}
        end

        def samples
          @samples ||= {}
        end
      end
    end
  end
end
