FROM ruby:3.2.2

# Dependencias necesarias
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  curl \
  git \
  yarn \
  imagemagick \
  postgresql-client \
  gnupg2

# Activar Corepack y usar Yarn moderno
RUN corepack enable && corepack prepare yarn@4.0.2 --activate

# Crear carpeta y setear app
RUN mkdir /app
WORKDIR /app

# Clonar Chatwoot
RUN git clone https://github.com/chatwoot/chatwoot.git . && git checkout develop

# Instalar bundler y dependencias Ruby
RUN gem install bundler && bundle config set deployment 'true' && bundle install

# Instalar dependencias JS y precompilar assets
RUN yarn install --immutable && bundle exec rake assets:precompile

# Exponer puerto y correr Puma
EXPOSE 3000
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
