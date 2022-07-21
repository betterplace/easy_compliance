# EasyCompliance

Ruby toolkit for https://www.easycompliance.de

## Usage example

### Creating a CSV for initial upload of data

Use `EasyCompliance::Ref` to build refs for the records.

### Keeping data in sync

```ruby
# config/initializers/easy_compliance.rb
EasyCompliance.api_key  = 'my_key'
EasyCompliance.api_url  = 'https://example.com'
EasyCompliance.app_name = 'my_app'

# app/models/my_record.rb
class MyRecord < ActiveRecord::Base
  after_save do
    saved_change_to_name? && ComplianceJob.perform_async(self, name)
  end
end

# app/jobs/compliance_job.rb
class ComplianceJob
  def perform(record, value)
    return unless production_env?

    check = EasyCompliance::Client.submit(record: record, value: value)
    check.hit?   # true/false

    check.status # http response status e.g. 200
    check.body   # http response body
  end
end
```

## License

`EasyCompliance` is licensed under the [Apache 2.0 license](LICENSE.txt) and
Copyright 2021,2022 [betterplace / gut.org gAG](https://gut.org).
