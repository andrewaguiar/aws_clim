# AwsClim

AwsClim is a light wrapper around `aws cli` tool. it adds some convenience when calling the command and
dealing with the results.

  - Maps all aws services as a method on AwsClim instance.
  - Set format as JSON as default.
  - Deals with arguments as Array, Hash or simply string
  - Parses all results as JSON
  - Returns an `OpenStruct.new(error: true, success: false, data: err)` when error happens.
  - Returns an `OpenStruct.new(error: false, success: true, data: JSON.parse(out, object_class: OpenStruct))` when command returns successfuly.

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
result.data
```

## Warning

As AwsClim rely on aws cli executable, some services can be unavailable depending of your version.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AwsClim project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/aws_clim/blob/master/CODE_OF_CONDUCT.md).
