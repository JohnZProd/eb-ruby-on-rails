# Ruby On Rails Container in Elastic Beanstalk

https://hub.docker.com/repository/docker/johnzhang08265/sample-app-rails

```
git clone https://github.com/railstutorial/sample_app_rails_4
cd sample_app_rails_4/
```

Using ruby:2.0.0

```Dockerfile
FROM ruby:2.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY Rakefile /myapp/Rakefile
COPY config/ /myapp/config/
COPY db/ /myapp/db/
RUN bundle exec rake db:migrate

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
```

```
docker build .
```

## Test Locally

```
$ docker run -d --mount type=bind,source="/home/ec2-user/sample_app_rails_4",target=/myapp -p 80:3000 <image id>
```

PORTS MUST BE MAPPED
