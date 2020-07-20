# Api test

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/b37613212fe5429f83bac3f7dc0d186b)](https://app.codacy.com/manual/HeHuHdez/api_test?utm_source=github.com&utm_medium=referral&utm_content=HeHuHdez/api_test&utm_campaign=Badge_Grade_Dashboard)

## Requirements

This projects was built on: 

  + Docker Desktop 2.3.0.3

It uses a docker-compose file to build two containers one for a MySql database and one for the rails environment. If you wish to do the setup in your local machine these are the versions used for all the other programs

  + Ruby on Rails 5.2
  + Ruby 2.5.5
  + MySQL 5.7

## Setup

With docker: 

 1. Open a new terminal, clone this project and open the directory

    

``` bash
        git clone git@github.com:HeHuHdez/api_test.git
        cd api_test/
    ```

2. Inside the directory run the following commands

    

``` bash
        # with docker
        docker-compose up -d
        docker exec -it api_test_web_1 bash
       
        # Inside the container
        
        rails db:create db:migrate db:seed 
        
        # This will create all tables in our database and
        # populate the database with some records. 
        
        rails db:test:prepare
        
        # Once the database schema is done we need to copy it to
        # the test database
    ```

3. To run the tests

    

``` bash
        bundle exec rspec -f d

        # This will print out the test message.
         
        # If you want to update the swagger files 
        # you should add the following flags
        # --format Rswag::Specs::SwaggerFormatter --order defined
    ```

4. Once done, to see the test coverage open the file `./coverage/index.html`
5. You can visit the site by entering in your browser `localhost:3000` and you should be automatically redirected to the swagger documentation page. 

In a local environment: 

* Instead of running the container you should run `bundle install` and update the file `./config/database.yml` to use your database credentials, host and port. 

## Swagger

Once you have the site up and running you can visit the site and by default you should be redirected to the swagger page

![](public\swagger_home.png)

If you've never used swagger before it's really easy, just click on a URL to expand it. You can read some examples on how the app responds depending on the params. Or you can try it on your own. 

![](public\swagger_example.png)

## App structure

The app uses a simple Bearer Authentication method for all the requests, excluding the login url, in which we obtain our authentication token, and the swagger documentation. 

Since swagger can only store one example for response code I recommend executing all tests in documentation mode for the requests

``` bash
    bundle exec rspec spec/requests/ -f d
```

### Models

We make use of three models. `Product` to store our products, `Order` to store our orders and `OrderProduct` as a join table, since an Order can have more than one product. An order fails if it doesn't have any products at the moment of the creation. 

To see all the model validations I recommend executing all tests in documentation mode 

``` bash
    bundle exec rspec spec/models/ -f d
```

## Seeded values

The default user email is `apitest@test.com` and the password is `apitest123` . There are 10 products and 10 orders, each going from the id's 1 through 10. And each one is paired with each other (Product 1 with order 1). They have random quantities. 

## Heroku

You can visit the site live with the following url `https://apitest-hhernandez.herokuapp.com/` it's on the free tier for heroku, so only 10 active connections simultaneity are possible. In there you can find the swagger documentation. 
