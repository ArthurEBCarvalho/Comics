# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

1. gems:
1.1. rspec
1.2. faraday
1.3. devise
1.4. factorybot
1.5. ruby 2.5.7
1.6. rails 5.1.7
1.7. pry
1.8. dotenv

2. Run project:
2.1. bundle install
2.2. rake db:setup
2.3. rake db:migrate

3. Observações:
3.1. O sistema está considerando que a API é confiável e imutável. Caso não pudesse considerar isso, seria necessário criar os dados de comics e characters no banco do sistema.
3.2. Aplicar o Rubocop como actions
3.3. Se precisar acessar mais APIs, poderia fazer um base service do faraday
3.4. CI com Rspec
3.5. Ajustar a tela de login 
3.6. Deixar o layout responsivo