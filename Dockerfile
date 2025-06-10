FROM ruby:3.2.2

# Dependencias necesarias
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  curl \
  git \
  imagemagick \
  postgresql-client \
  gnupg2

# Instalar Yarn manualmente
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Crear carpeta y setear app
RUN mkdir /app
WORKDIR /app

# Clonar Chatwoot
RUN git clone https://github.com/chatwoot/chatwoot.git . && git checkout develop

# Instalar bundler y dependencias Ruby
RUN gem install bundler && bundle config set deployment 'true' && bundle install

# Instalar dependencias JS y precompilar assets
RUN yarn install && bundle exec rake assets:precompile

# Exponer puerto y correr Puma
EXPOSE 3000
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
