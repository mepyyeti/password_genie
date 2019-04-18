# PasswordGenie

a tool that:
1. generates a custom password/pin numbers based on a user's specifications
2. store password/pin and corresponding usernames and site names
3. introduces a search function to retrieve user info and
4. allows a user to push an already existing password, site, and username info into a sqlite db

This version includes general bug fix and bundle migration.

To ensure data preservation, relocate db file when updating.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mepyyeti/password_genie. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PasswordGenie project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/password_genie/blob/master/CODE_OF_CONDUCT.md).
