FROM ruby:3.4.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    vim \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
