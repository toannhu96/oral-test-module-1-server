# build phase
FROM node:16.9.0-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --only=production

# production phase
FROM node:16.9.0-alpine

# change timezone to Asia/Ho_Chi_Minh
RUN apk add --no-cache tzdata
ENV TZ Asia/Ho_Chi_Minh
RUN rm -rf /etc/localtime\
    && cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# install pm2
RUN npm install pm2 -g

ENV NODE_ENV production
USER node
WORKDIR /usr/src/app
COPY --chown=node:node --from=build /usr/src/app/node_modules /usr/src/app/node_modules
COPY --chown=node:node . /usr/src/app

EXPOSE 3000
CMD ["pm2-runtime", "server.js"]