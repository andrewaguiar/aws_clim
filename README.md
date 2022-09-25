# AwsClim

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/aws_clim`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AwsClim project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/aws_clim/blob/master/CODE_OF_CONDUCT.md).
