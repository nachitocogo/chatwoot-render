FROM chatwoot/chatwoot:latest

ENV RAILS_ENV=production
ENV NODE_ENV=production

EXPOSE 3000

CMD [ "bin/docker-start" ]
