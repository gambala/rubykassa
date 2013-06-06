# -*- encoding : utf-8 -*-
module Rubykassa
  module SignatureGenerator
    def generate_signature_for kind
      raise ArgumentError, "Available kinds are only :payment, :result or :success" if ![:success, :payment, :result].include? kind
      custom_param_keys = @params.keys.select {|key| key =~ /^shp/ }.sort
      custom_params = custom_param_keys.map {|key| "#{key}=#{params[key]}"}
      custom_params_string = custom_params.present? ? ":#{custom_params}" : ""

      if kind == :payment  
        string = [Rubykassa.login, @total, @invoice_id, Rubykassa.first_password].join(":") + custom_params_string
      elsif kind == :result
        string = [@total, @invoice_id, Rubykassa.second_password].join(":") + custom_params_string
      elsif kind == :success
        string = [@total, @invoice_id, Rubykassa.first_password].join(":") + custom_params_string
      end

      signature = Digest::MD5.hexdigest(string)
    end
  end
end