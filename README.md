# services
A docker setup to get maputnik running locally

[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)][stability]

[stability]:   https://github.com/orangemug/stability-badges#experimental

**WARNING** Although working, this isn't really intended for use at the moment.


Locally these are

 - <http://localhost:8000/> → [website](github.com/maputnik/website)
 - <http://localhost:8000/editor> → [editor](github.com/maputnik/editor)
 - <http://localhost:8000/gatekeeper> → [gatekeeper](https://github.com/prose/gatekeeper)

These all run through a [haproxy](http://www.haproxy.org/).



### Enviroment variables
There are certain keys that are required to get a fully working maputnik locally.

#### gatekeeper 
Our micro-github instance expects github OAuth id and secrets.

```bash
# Add to your ~/.profile or ~/.bashrc
export GK_OAUTH_CLIENT_ID=000000000000
export GK_OAUTH_CLIENT_SECRET=000000000000
```

Where `000000000000` is replaced with your details.


## Usage
Make sure you have [docker](https://www.docker.com/) installed and run

```
docker-compose build
```

This may take a while to complete depending on your internet connection. Once complete start the apps with

```
docker-compose up
```

Now head to <http://localhost:8080> and explore maputnik running on your local machine.

## License
[MIT](LICENSE)

