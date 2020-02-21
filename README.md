# maputnik-services
**WARNING** Although working, it's not indended for use yet. It still needs some further testing.

A docker setup to get Maputnik running locally intended for easy development. Join the crew!

[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)][stability]

[stability]:   https://github.com/orangemug/stability-badges#experimental


Locally these are

 - <http://localhost:8000/> → [website](github.com/maputnik/website)
 - <http://localhost:8000/editor> → [editor](github.com/maputnik/editor)
 - <http://localhost:8000/auth/github> → [micro-github](https://github.com/mxstbr/micro-github)

These all run through a [haproxy](http://www.haproxy.org/).


## Setup
To get this up and running locally you'll need all the apps cloned to the same directory as this repo. We use symlinks in the [./apps](/apps) directory so the exact location is important. A directory structure like the following is recommended

```
maputnik
├── editor
├── services
└── website
```

**Note:** We use symlinks so developing the apps is easier, all the code is checked out already so you can make a pull request to any part of the application.


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

You also need to install any deps for services from inside the container. To do that run

```bash
$ docker-compose run <SERVICE_NAME> bash
$ npm install <NPM_PKG_NAME> --save
```

So on first boot you'll need to run

```bash
$ docker-compose run editor bash
$ npm install
```


### Enviroment variables
Host machine environment variables.
There are certain keys that are required to get a fully working maputnik locally.

#### micro-github (not currently required)
Our micro-github instance expects github OAuth id and secrets.

```bash
# Add to your ~/.profile or ~/.bashrc
export MAPUTNIK_TEST_GH_CLIENT_ID=000000000000
export MAPUTNIK_TEST_GH_CLIENT_SECRET=000000000000
```

Where `000000000000` is replaced with your details.

## License
[MIT](LICENSE)

