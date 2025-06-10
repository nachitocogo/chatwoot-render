FROM chatwoot/chatwoot:latest

ENV RAILS_ENV=production
ENV NODE_ENV=production

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:chatwoot_prepare && bundle exec puma -C config/puma.rb"]
