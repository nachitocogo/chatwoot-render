FROM ruby:3.4.4

# Actualiza e instala dependencias básicas + Node.js 18 (con Corepack)
RUN apt-get update -qq && apt-get install -y \
  curl gnupg2 build-essential libpq-dev git \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Activar Corepack y Yarn 4+
RUN corepack enable && corepack prepare yarn@4.0.2 --activate

# Crear app y setear directorio
RUN mkdir /chatwoot
WORKDIR /chatwoot

# Clonar ChatWoot
RUN git clone https://github.com/chatwoot/chatwoot.git . && git checkout develop

# Instalar dependencias Ruby
RUN gem install bundler && bundle install

# Precompilar assets con Yarn moderno
RUN yarn install --immutable && yarn build

# Exponer puerto
EXPOSE 3000

# Comando de inicio
CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
