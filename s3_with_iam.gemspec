# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_with_iam/version'

Gem::Specification.new do |spec|
  summary = %q{A tool for interacting with S3 using the AWS IAM roles from the local instance}
  spec.name          = "s3_with_iam"
  spec.version       = S3WithIam::VERSION
  spec.authors       = ["Andrew Rollins"]
  spec.email         = ["gems@andrewrollins.com"]
  spec.description   = summary
  spec.summary       = summary
  spec.homepage      = "https://github.com/andrew311/s3-with-iam"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"

  spec.add_runtime_dependency "aws-sdk",  "~> 1.42.0"
  spec.add_runtime_dependency "json",     "~> 1.8.1"
  spec.add_runtime_dependency "trollop",  "2.0"
end
