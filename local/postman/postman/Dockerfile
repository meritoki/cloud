FROM node:8-alpine
WORKDIR /
COPY ./ /
RUN apk add git
RUN apk add nano
RUN npm install
RUN npm install newman -g
RUN newman run ./postman/daily-bread-auth-service.postman_collection.json --reporters cli,junit --reporter-junit-export newman.xml --insecure

