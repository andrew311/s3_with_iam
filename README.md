# S3 Get with IAM

This is a tool for retreiving a file from S3 by using the local instance’s IAM roles.

Example:

```
./s3-get-with-iam.rb --bucket example --key foo/example.txt --destination local/example.txt
```

* `key` is the path on S3
* `destination` is where you want to write the file locally

See more help with `./s3-get-with-iam.rb -h`