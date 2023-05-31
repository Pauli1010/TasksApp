# README - IN PROGRESS

This README would normally document whatever steps are necessary to get the
application up and running. As this is the template App, you can find information needed for
running it as it is and things that need to be done further.


* Ruby version

2.7.5

* System dependencies

* Configuration

Since this is template app, first thing to do is to change all the defaults:
- DB names in file: config/database.yml
- APP NAME in whole project, by searching for: StartApp or Start App
If needed, add .env file with all the environment variables, that you need to change.

* Database creation

* Database initialization

* How to run the test suite

You can run all tests with command: `rspec` or `bundle exec rspec`
For running only tests from one file run: `rspec <path_to_file>`
For running one test run: `rspec <path_to_file>:<line_number>`

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Development instructions

This template project holds some elements, that need to be changed or removed, based on the needs. 
Below is the list of files or methods that need to be reviewed for that purpose:
- app/assets/stylesheets/spare_css.scss - File with additional styles
- app/controllers/application_controler.rb - For projects with public access, the `before_action :require_login` may need to be moved
- app/mailers/user_mailer.rb#activation_success_email(user) - Currently unused method
- config/locales/mailers.pl.yml - Translations used in mailers. In case of using second party app for sending emails, this file may be changed or deleted.

User methods:
- method `initials` - Currently returns first letter of user_name