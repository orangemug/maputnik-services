FROM node:8

EXPOSE 9999

ENV HOME /gatekeeper
RUN mkdir ${HOME}

COPY . ${HOME}/

WORKDIR ${HOME}

RUN npm install

CMD node index.js
