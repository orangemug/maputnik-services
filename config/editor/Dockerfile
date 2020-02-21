FROM node:13

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python \
    default-jdk \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 8888

ENV HOME /maputnik
RUN mkdir ${HOME}

COPY . ${HOME}/
WORKDIR ${HOME}

WORKDIR ${HOME}/build/build
CMD python -m SimpleHTTPServer 8888
