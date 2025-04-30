FROM node:20

WORKDIR /app

COPY . .

# install dependencies
RUN npm install

ENTRYPOINT [ "node", "index.js" ]