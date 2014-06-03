#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'json'
require 'aws-sdk'

class S3WithIAM

  CRED_ROOT_URL = 'http://169.254.169.254/latest/meta-data/iam/security-credentials/'

  def errputs(*args)
    STDERR.puts(*args)
  end

  def get_uri(uri)
    url = URI.parse(uri)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    res.body
  end

  def get_roles
    begin
      get_uri(CRED_ROOT_URL).
        split("\n").
        map{|s| s.strip}.
        select{|s| s != '' && !s.nil?}
    rescue
      errputs "Error retreiving role names from metadata"
      []
    end

  end

  def get_creds(roles)
    roles = roles.is_a?(Array) ? roles : roles.to_s.split(',')
    begin
      roles.inject({}) do |hash, role|
        json = get_uri("#{CRED_ROOT_URL}/#{role}/")
        cred =
          begin
            JSON.parse(json)
          rescue
            errputs "Did not find valid role for '#{role}'"
          end
        hash[role] = cred if cred
        hash
      end
    rescue
      errputs "Error retreiving credentials from IAM metadata"
      {}
    end
  end

  def get(options)
    get_creds(options[:roles] || get_roles).each.find do |role, cred|
      begin
        puts "Trying download using role #{role}"
        s3 = AWS::S3.new(
          :access_key_id => cred['AccessKeyId'],
          :secret_access_key => cred['SecretAccessKey'],
          :session_token => cred['Token'],
          :region => options[:region]
        )
        File.open(options[:destination], 'wb') do |file|
          s3.buckets[options[:bucket]].objects[options[:key]].read do |chunk|
              file.write(chunk)
          end
        end
        puts "File downloaded to #{options[:destination]}"
        true
      rescue AWS::S3::Errors::AccessDenied
        errputs "Access denied on S3 object for role #{role}"
        false
      end
    end
  rescue AWS::S3::Errors::NoSuchBucket
    errputs "No such bucket '#{options[:bucket]}'"
  end

end
