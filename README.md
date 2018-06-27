# Maputnik services

A docker setup to get maputnik running locally.
Build on top of [@orangemug work](https://github.com/orangemug/maputnik-services).

Locally these are

 - <http://localhost:8080/> → [editor](github.com/maputnik/editor)
 - <http://localhost:8080/gatekeeper> → [gatekeeper](https://github.com/prose/gatekeeper)

These all run through a [haproxy](http://www.haproxy.org/).


### Enviroment variables
There are certain keys that are required to get a fully working maputnik locally.

#### gatekeeper 
Our gatekeeper instance expects github OAuth id and secrets.


## Usage
Make sure you have [docker](https://www.docker.com/) installed and run.

```
git subdmodule update --init
make user
make dockerbuild
```

This may take a while to complete depending on your internet connection. Once complete start the apps with

```
make dockerrun
```

Now head to <http://localhost:8080> and explore maputnik running on your local machine.

## License
[MIT](LICENSE)

## TODO
  - Encapsulate the docker-compose for rancher deploy
