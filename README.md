# Ruby On Rails Container in Elastic Beanstalk

This repository deploys a containerised Ruby on Rails into Elastic Beanstalk running Multi-container Docker.

The sample app used is the railstutorial sample_app_rails_4 app, which is has simple login/signup functionality. It uses Ruby 2.0.0
https://github.com/railstutorial/sample_app_rails_4

The finished Docker image is found on my Dockerhub here
https://hub.docker.com/repository/docker/johnzhang08265/sample-app-rails

## Setting up

Clone this repository and run the setup script, which will clone the application bundle into your workspace and remove any .git subfolders which may cause unwanted behaviour with Elastic Beanstalk

```
git clone https://github.com/JohnZProd/eb-ruby-on-rails.git
sh setup.sh
```

The Dockerfile looks like this. Note that the entrypoint.sh script will run in the container everytime it is run

```Dockerfile
FROM ruby:2.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
```

To build the image

```
cd sample_app_rails_4/
docker build .
```

At this stage, push the image into your image respository

## Test Locally

```
$ docker run -d --mount type=bind,source="/home/ec2-user/sample_app_rails_4",target=/myapp -p 80:3000 <image id>
```

## Deploying onto Elastic Beanstalk

From the root directory of this repo

```
cd <path to>/eb-ruby-on-rails
```

```json
{
    ///
    "containerDefinitions": [
      {
       	"name": "sample-app-rails",
        "image": "<image repository>/<image name>",
        "essential": true,
        //
      }
    ]
}
```

Initialise the Elastic Beanstalk repository and deploy to environment 

```
eb init <application-name>
eb deploy <environment-name>
```