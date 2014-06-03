# S3 with IAM

A tool for interacting with S3 using the AWS IAM roles from the local instance (i.e., this tool is meant to be run on an EC2 instance with IAM roles).

Right now it just supports getting a file from S3. In its simpliest form, it will auto-discover the roles on the local instance and try each one until it downloads the file or runs out of roles.

## Installation

Add this line to your application's Gemfile:

    gem 's3_with_iam'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_with_iam

The gem includes the `s3_with_iam` command line tool.

## Usage

Getting a file out of S3 (using auto-discovered IAM roles):

    s3_with_iam --bucket example --key foo/example.txt --destination local/example.txt

* `bucket` is the bucket on S3
* `key` is the path on S3 within the bucket
* `destination` is where you want to write the file locally

See all available options with:

    s3_with_iam -h

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
