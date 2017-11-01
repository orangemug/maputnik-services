# services
A docker setup to get maputnik running locally

[![stability-unstable](https://img.shields.io/badge/stability-unstable-yellow.svg)][stability]

[stability]:   https://github.com/orangemug/stability-badges#unstable


Locally these are

 - <http://localhost:8000/> -> [website](github.com/maputnik/website)
 - <http://localhost:8000/editor> -> [editor](github.com/maputnik/editor)
 - <http://localhost:8000/auth/github> -> [micro-github](https://github.com/mxstbr/micro-github)

These all run through a [haproxy](http://www.haproxy.org/) locally. In production we will use [zeit now](https://zeit.co/now) and the [path-alias](https://zeit.co/blog/path-alias) to host the apps


## Setup
To get this up and running locally you'll need all the apps cloned to the same directory as this repo. We use symlinks in the [./apps](/apps) directory so the exact location is important. A directory structure like the following is recommended

```
maputnik
├── editor
├── services
└── website
```

**Note:** We use symlinks so hacking on apps is easier, all the code is checked out already so you can make a pull request to any part of the application.


### Enviroment variables
There are certain keys that are required to get a fully working maputnik locally.

#### micro-github 
Our micro-github instance expects github OAuth id and secrets.

```bash
# Add to your ~/.profile or ~/.bashrc
export MAPUTNIK_TEST_GH_CLIENT_ID=000000000000
export MAPUTNIK_TEST_GH_CLIENT_SECRET=000000000000
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

