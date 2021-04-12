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
    production_env? &&
      EasyCompliance::Client.submit(record: record, value: value)
  end
end
```
