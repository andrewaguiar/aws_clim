# AwsClim

AwsClim is a light wrapper around `aws cli` tool. it adds some convenience when calling the command and
dealing with the results.

  - Maps all aws services as a method on AwsClim instance.
  - Set format as JSON as default.
  - Deals with arguments as Array, Hash or simply string
  - Parses all results as JSON
  - Returns an `OpenStruct.new(error: true, success: false, data: err)` when error happens.
  - Returns an `OpenStruct.new(error: false, success: true, data: JSON.parse(out, object_class: OpenStruct))` when command returns successfuly.

All results are converted to OpenStruct objects recursivelly, so no need to handle Hash objects like `result.data['AttributeA']['AttributeB']`,
instead just call `resut.data.AttributeA.AttributeB`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_clim'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aws_clim

## Usage

```
aws = AwsClim.new()
```

By calling new without parameters AwsClim uses the profile `default`(see https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_profiles.html to learn about aws profiles).
To set a different profile use profile argument on new.

```
aws = AwsClim.new(profile: 'other-profile')
```

With a instance of AwsClim call aws services by its name and pass subcommands and options:

Examples:

```
# Subcommand

aws.iam('list-users').data.Users
```

```
# Subcommand + Arguments

result = aws.apigateway('put-method-response', {
  'rest-api-id'         => rest_api['id'],
  'resource-id'         => resource['id'],
  'http-method'         => 'GET',
  'status-code'         => '200',
  'response-parameters' => 'method.response.header.access-control-allow-origin=false'
})

result.success?
result.error?
result.data # data is a nested OpenStruct with all json returned from cli.
```

## Exit on fail option

All services have a `!` option that simply exit(1) program when result is an error, so instead of doing:

```
result = aws.dynamodb('update-table', {
  'table-name': table,
  'attribute-definitions': attribute-definitions,
  'global-secondary-index-updates': indexes
})

if result.error?
  puts result.data
  exit(1)
end
```

You can simply call the `!` version:

```
result = aws.dynamodb!('update-table', {
  'table-name': table,
  'attribute-definitions': attribute-definitions,
  'global-secondary-index-updates': indexes
})
```

if `aws dynamodb update-table` command fails it will `exit(1)` from your program, so you don't need to
check for `result.error?`.

## Command + help

All services have a `_help` option as well that simply executes a `command help` and returns the text.

```
puts a.ec2_help
```

result:

```
EC2()                                                                    EC2()



NAME
       ec2 -

DESCRIPTION
       Amazon Elastic Compute Cloud (Amazon EC2) provides secure and resizable
       computing capacity in the AWS Cloud. Using Amazon  EC2  eliminates  the
       need  to invest in hardware up front, so you can develop and deploy ap-
       plications faster. Amazon Virtual Private Cloud  (Amazon  VPC)  enables
       you  to  provision  a logically isolated section of the AWS Cloud where
       you can launch AWS resources in a virtual network that you've  defined.
       Amazon  Elastic  Block  Store (Amazon EBS) provides block level storage
       volumes for use with EC2 instances. EBS volumes  are  highly  available
       and  reliable  storage  volumes that can be attached to any running in-
       stance and used like a hard drive.

       ...
```

## Warning

As AwsClim rely on aws cli executable, some services can be unavailable depending of your version.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AwsClim project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/aws_clim/blob/master/CODE_OF_CONDUCT.md).
