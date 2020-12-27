# Movie application

This a very basic movie application where you can add movies you want to watch.
You list all these movies and you're also able to remove a movie which you don't want to see anymore.
At last you can also mark a movie as "watched". 
The fronted is just plain Javascript and HTML/CSS. The backend is written in Go and uses the gin-gonic framework.
The movies are stored in a NoSQL MongoDB which is prefilled with some movies. Everything will run in Kubernetes. 

it supports the following cases:
- add a movie
- remove a movie
- list all movies
- put a movie as 'watched'

# Run the application locally
```
$ docker-compose build && docker-compose up -d
```

# Verify application
```
$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED              STATUS              PORTS                                  NAMES
8ce99d6f6934   mongo-express         "tini -- /docker-ent…"   5 seconds ago        Up 4 seconds        0.0.0.0:8081->8081/tcp                 mongo-express
61f06e482e88   application_backend   "./main"                 About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp                 backend
dfb9c9a0fc7b   mongo                 "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:27017-27019->27017-27019/tcp   mongo
```

# Backend API
Add a movie
```
$ curl localhost:8080/movies -d '{"title": "The Dark Knight", "year": 2008, "Watched":false }'
{"id":"5fe8d41419678cfd2ab2c6e1"}
```

List all movies
```
$ curl localhost:8080/movies
{"movies":[{"_id":"5fe8d41419678cfd2ab2c6e1","title":"The Dark Knight","year":2008,"watched":false},{"_id":"5fe8d4a319678cfd2ab2c6e2","title":"Zodiac","year":2007,"watched":false}]}
```

Put a movie as watched
```
$ curl -X PUT -H "Content-Type: application/json" -d '{"_id":"5fe8d4a319678cfd2ab2c6e2"}' localhost:8080/movies
""
```

Get a specific movie
```
$ curl localhost:8080/movies/5fe8d4a319678cfd2ab2c6e2
{"id":"5fe8d4a319678cfd2ab2c6e2","title":"Zodiac","watched":true,"year":2007}
```

Delete a movie
```
$ curl -XDELETE localhost:8080/movies/5fe8d41419678cfd2ab2c6e1
""
```