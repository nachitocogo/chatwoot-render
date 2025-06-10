FROM ruby:3.4.4

# Dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Crear app
RUN mkdir /chatwoot
WORKDIR /chatwoot

# Instalar ChatWoot
RUN git clone https://github.com/chatwoot/chatwoot.git . && git checkout develop

# Instalar gems y paquetes
RUN gem install bundler && bundle install

# Precompilar assets
RUN yarn && yarn build

# Exponer puerto
EXPOSE 3000

# Start command con migraciones
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
