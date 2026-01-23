FROM ruby:3.3

# Install OS deps commonly needed for Rails + DB adapters
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  nodejs \
  git \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems first (better layer caching)
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the rest
COPY . .

# Expose Rails default port
EXPOSE 3000

# Default command (override in compose if needed)
CMD ["bash", "-lc", "bundle exec rails server -b 0.0.0.0 -p 3000"]