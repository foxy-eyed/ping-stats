# frozen_string_literal: true

class Ipv4 < Grape::Validations::Validators::Base
  ERROR_MSG = "must be an IPv4 address"

  def validate_param!(attr_name, params)
    ip = IPAddr.new(params[attr_name])
    fail!(attr_name) unless ip.ipv4?
  rescue IPAddr::InvalidAddressError
    fail!(attr_name)
  end

  private

  def fail!(attr_name)
    raise Grape::Exceptions::Validation.new(params: [@scope.full_name(attr_name)], message: ERROR_MSG)
  end
end
