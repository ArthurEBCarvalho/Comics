# Comics

Comics is a Ruby on Rails app that connects with [Marvel API](https://developer.marvel.com/) to get the comics, can filter by character and also bookmark a comic.
This app was made in `ruby 2.5.7` and `rails 5.1.7`.

## Services

Comics uses the following gems:
* [Rspec Rails](https://github.com/rspec/rspec-rails)
* [Faraday](https://github.com/lostisland/faraday)
* [Devise](https://github.com/heartcombo/devise)
* [FactoryBot](https://github.com/thoughtbot/factory_bot)
* [Pry Rails](https://github.com/rweng/pry-rails)
* [Dotenv](https://github.com/rweng/pry-rails)

## Instalation

Run the following commands to start this app localy:
* `bundle install` to install the gems;
* `rake db:setup` to create the database;
* `rake db:migrate` to create the tables on database;
* `rails s` to start the server localy.

Now, you have to access `localhost:3000` on browser, create you user and enjoy the Marvel comics.

## Comments:

The app is considering the Marvel API to be reliable and immutable. If you could not consider this, it would be necessary to create the comics and characters data in the system database.
If I had more time, I could make the following improvements: 

* Github actions with Rubocop and Rspec
* Login page
* Responsive layout