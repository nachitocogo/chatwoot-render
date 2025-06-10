FROM ruby:3.4.4

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

# Instalar Node.js 18 y Yarn clásico
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.22

# Crear carpeta y setear app
RUN mkdir /app
WORKDIR /app

RUN git clone https://github.com/chatwoot/chatwoot.git . && \
    git checkout develop && \
    sed -i '/"packageManager":/d' package.json

# Instalar bundler y dependencias Ruby
RUN gem install bundler && bundle config set deployment 'true' && bundle install

# Instalar dependencias JS y precompilar assets
RUN yarn install && bundle exec rake assets:precompile

# Exponer puerto y correr Puma
EXPOSE 3000
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
