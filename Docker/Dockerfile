# Use an official Ruby runtime as a parent image
FROM ruby:3.0.6-slim-buster

# Add github repository
ADD https://github.com/pioneerworks/ruby-sample-app /app

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    nodejs

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install Ruby gems with bundle to leverage Docker cache
RUN gem install bundler
RUN bundle install --without development test

# Copy the rest of the application code into the container
COPY . /app

# Expose the port that the application will run on
EXPOSE 3000

# Set the environment to production
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Start the application using Rail
CMD rm -f tmp/pids/server/pid && rails s -b '0.0.0.0'