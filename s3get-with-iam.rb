#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'json'
require 'aws-sdk'
require 'trollop'

class S3GetWithIAM
  def get_uri(uri)
    url = URI.parse(uri)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    res.body
  end

  def get_creds
    cred_names = get_uri('http://169.254.169.254/latest/meta-data/iam/security-credentials').
      split("\n").map{|s|s.strip}.select{|s|s != '' && !s.nil?}

    cred_names.inject({}) do |hash, cred_name|
      json = get_uri("http://169.254.169.254/latest/meta-data/iam/security-credentials/#{cred_name}")
      hash[cred_name] = JSON.parse(json) rescue nil
    end.select{|k,v| v}
  end

  def download_s3object(options)
    get_creds.find do |cred_name, cred|
      s3 = AWS::S3.new(
        :access_key_id => cred['AccessKeyId'],
        :secret_access_key => cred['SecretAccessKey'],
        :region => options[:region]
      )
      File.open(destination, 'wb') do |file|
        s3.buckets[bucket].objects[key].read do |chunk|
          file.write(chunk)
        end
      end
    end
  end

end

if __FILE__ == $0
  options = Trollop::options do
    opt :bucket, "bucket", :type => string, :short => '-b'
    opt :key, "S3 object key", :type => string, :short => '-k'
    opt :destination, "Local file destination", :type => string, :short => '-o'
    opt :region, "AWS region", :type => string, :short => '-o', :default => 'us-east-1'
  end
  S3GetWithIAM.new.download_s3object(options)
end
