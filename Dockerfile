FROM ruby:3.4.4

# Dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  curl

# Instalar Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn

# Crear app
RUN mkdir /chatwoot
WORKDIR /chatwoot

# Instalar ChatWoot
RUN git clone https://github.com/chatwoot/chatwoot.git . && git checkout develop

# Instalar gems
RUN gem install bundler && bundle install

# Precompilar assets
RUN yarn && yarn build

# Exponer puerto
EXPOSE 3000

# Comando final
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
