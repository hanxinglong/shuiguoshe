require 'openssl'
require 'base64'

module Alipay
  module Sign
    
    PEM = "-----BEGIN PUBLIC KEY-----\n" \
          "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRA\n" \
          "FljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQE\n" \
          "B/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5Ksi\n" \
          "NG9zpgmLCUYuLkxpLQIDAQAB\n" \
          "-----END PUBLIC KEY-----"
    
    def self.verify?(params)
      params = Alipay.stringify_keys(params)
      
      pub_key = OpenSSL::PKey::RSA.new(PEM)
      digest = OpenSSL::Digest::SHA1.new
      
      params.delete('sign_type')
      sign = params.delete('sign')
      to_sign = params.sort.map { |item| item.join('=') }.join('&')
      
      pkey.verify(digest, Base64.decode64(sign), to_sign)
    end
  end
  
  module Notify
    def self.verify?(params)
      params = Alipay.stringify_keys(params)
      Sign.verify?(params) && Alipay.verify_notify_id?(params['notify_id'])
    end
  end
  
  private
  
  def self.stringify_keys(hash)
    new_hash = {}
    hash.each do |key, value|
      new_hash[(key.to_s rescue key) || key] = value
    end
    new_hash
  end
  
  def self.verify_notify_id?(notify_id)
    open("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Setting.partner}&notify_id=#{CGI.escape(notify_id.to_s)}").read == 'true'
  end
  
end