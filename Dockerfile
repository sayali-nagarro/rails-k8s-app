# Build stage
FROM ruby:3.3.6-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    postgresql-dev \
    tzdata \
    curl \
    bash

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Final stage
FROM ruby:3.3.6-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache \
    postgresql-client \
    tzdata \
    bash \
    curl \
    busybox-extras

# Copy application from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Copy application code
COPY . .

# Create entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app /usr/local/bundle

USER appuser

EXPOSE 3000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
