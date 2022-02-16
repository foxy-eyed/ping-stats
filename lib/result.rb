# frozen_string_literal: true

module Result
  class NonExistentError < StandardError; end
  class NonExistentValue < StandardError; end

  class Success
    def initialize(value = nil)
      @value = value
      freeze
    end

    def success?
      true
    end

    def failure?
      false
    end

    def error
      raise NonExistentError, "Success result does not have error"
    end

    attr_reader :value
  end

  class Failure
    NonExistedValueError = Class.new(StandardError)

    def initialize(error = nil)
      @error = error
      freeze
    end

    def success?
      false
    end

    def failure?
      true
    end

    def value
      raise NonExistentValue, "Failure result does not have value"
    end

    attr_reader :error
  end
end
