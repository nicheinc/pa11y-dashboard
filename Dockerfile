FROM node:15

ARG NODE_ENV=docker
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 libxtst6 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN chown node:node /app

COPY --chown=node:node . /app

RUN if [ ! -f /app/config/{$NODE_ENV}.json ]; then cp /app/config/${NODE_ENV}.sample.json /app/config/${NODE_ENV}.json; fi

RUN usermod -a -G audio,video node

USER node

RUN npm install

EXPOSE 4001

CMD ["node", "index.js"]
