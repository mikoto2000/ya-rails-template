FROM mcr.microsoft.com/devcontainers/ruby:3.4-bookworm
LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs

RUN gem install rails

