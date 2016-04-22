# Job Notifier

It's a Rails engine built on top of [Active Job](https://github.com/rails/activejob) in order to **improve user experience related to background processes**. To achieve this goal, the gem allows us to:

1. **Relate jobs with entities**

 Using [Active Job](https://github.com/rails/activejob), you can perform background jobs but, you can not relate them with, for example, a logged user. Job Notifier allows you to connect an entity with a job easily.

1. **Persist job results**

 Using [Active Job](https://github.com/rails/activejob), you can run jobs in background but, you are not be able to store the result of those jobs. This is a desired behavior if you, for example, want to provide validation feedback to users.

1. **Notify users when their jobs change state.**

 Using [Active Job](https://github.com/rails/activejob), you can run jobs in background but, you lose a real time response. To bring a solution to this issue, Job Notifier, through polling technique,  gives you a way to know what's happening with your jobs.

## Installation

Add to your Gemfile:

```ruby
gem "job_notifier"
```

```bash
bundle install
```

Run the installer:

```bash
rails generate job_notifier:install
```

> The installer will copy `/config/initializers/job_notifier.rb`. There, you can change the default configuration.

Then, include `notifier.js` where you go to use it. For example, in: `/app/assets/javascripts/application.js`

```javascript
//= require job_notifier/notifier
```

## Flow

1. An **entity** (`current_user` for example), creates a job.
1. The job related to the `current_user` is queued with `"pending"` status.
1. The `js` code stored on `notifier.js` executes, using the polling technique, a request asking for the jobs related to the `current_user`. The result is an array containing the created job with `"pending"` status.
1. After a few seconds, a new request is performed but, this time, it returns an empty array. This occurs because the created job didn't change its status.
1. After a couple of request with empty arrays, an object its returned with `"finished"` or `"failed"` status and a `result` attribute containing feedback.

## Usage

**First**, relate jobs with an entity (`User` for example). To do this, include the `JobNotifier::Identifier` mixin
in your entity class and execute the `identify_job_through` method, passing the attributes you want to use to build the key to identify jobs for the entity. For example, if you have defined the `User` class like this,

```ruby
class User < ActiveRecord::Base
  include JobNotifier::Identifier

  identify_job_through :id, :email
end

user = User.create!(email: "leandro@platan.us")
# => #<User:0x007f877ef5c2a8 id: 1, email: "leandro@platan.us">
```

the jobs for `user` will be identified by this code: `"1b1bcc253675df5eb91603dbda06af11"`. (This is result of: `Digest::MD5.hexdigest("email::leandro@platan.us::id::1")`, if you wanna know)

**Second**, pass to `notifier.js` the identifier for that user. This is because the timed requests (polling) needs to know from what user bring the data. To do this, you can use the helper shipped in the gem:

```
<body <%= job_identifier_for(@current_user) %>>
```

```html
<!-- Something like this is what the previous code produces -->
<body data-identifier="1b1bcc253675df5eb91603dbda06af11" data-root-url="/">
```

> I'm assuming you have a `current_user` instance of `User` class.

The previous code, takes the identifier from `@current_user` and sets a data attribute, on body tag, that will be used in somewhere of `notifier.js` to perform requests with a valid identifier.

To catch the response of polling requests, you can set a callback function:

```javascript
JobNotifier.onNotify = function(data) {
  console.info('On notify', data);
};

```

Now, you are be able to get feedback of your jobs but, you don't have any! so, the **Third** step is to define a job.

```ruby
class MyJob < ActiveJob::Base
  def perform_with_feedback(param1, param2)
    MyService.run(param1, param2)
  end
end
```

As you can see, the only difference with a regular ActiveJob's job is that you have `perform_with_feedback` method instead of `perform` method. Inside `perform_with_feedback` you need to return the "success response" of your job. And, to save the "error response", you need to raise a `JobNotifier::Error::Validation` exception. Let's see `MyService#run` method definition to make it clear.

```ruby
class MyService
  def self.run(param1, param2)
    return "SUCCESS!!!" if param1 == param2
    raise JobNotifier::Error::Validation.new(error: "ERROR!!!")
  end
end
```

> If you define `perform` instead of `perform_with_feedback`, ActiveJob will work as always do.

The **Fourth** step is queue a new job. Executing `JobNotifier::Job.where(identifier: current_user.job_identifier)` you can see jobs related with the passed identifier. So, according to `MyService#run` definition:

The following code: `MyJob.perform_later(current_user.job_identifier, "lean", "lean")` will create a new `JobNotifier::Job` instance with:

- `result: nil`
- `state: "pending"`

After execution, the job will have:

- `result: "SUCCESS!!!"`
- `state: "finished"`

If this code `MyJob.perform_later(current_user.job_identifier, "lean", "leandro")` is executed instead of the previous one, the result will be:

- `result: "ERROR!!!"`
- `state: "failed"`

## Non Rails Client App

If you are building an API or your client app is not part of the project you have installed this gem, you will need:

- To include the `notifier.js` using this url: `http://your_app.platan.us/job_notifier/adapters/notifier`
- To mimic the `job_identifier_for` functionality, passing `data-identifier` and `data-root-url`

 ```html
 <body data-identifier="1b1bcc253675df5eb91603dbda06af11" data-root-url="http://your_app.platan.us/">
 ```

 You can get the identifier executing in server side something like this: `@current_user.job_identifier` (Remember, I'm assuming you have a `@current_user` instance of `User` class that includes the `JobNotifier::Identifier` mixin).

 The root url is your server url (where Job Notifier gem was installed).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/job_notifier/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Job Notifier is maintained by [platanus](http://platan.us).

## License

Job Notifier is © 2016 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
