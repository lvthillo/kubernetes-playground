# Backend API

Add a movie
```
$ curl localhost:8080/movie -d '{"title": "The Dark Knight", "year": 2008, "Watched":false }'
{"id":"5fe8d41419678cfd2ab2c6e1"}
```

List all movies
```
$ curl localhost:8080/movie
{"movies":[{"_id":"5fe8d41419678cfd2ab2c6e1","title":"The Dark Knight","year":2008,"watched":false},{"_id":"5fe8d4a319678cfd2ab2c6e2","title":"Zodiac","year":2007,"watched":false}]}
```

Put a movie as watched
```
$ curl -X PUT -H "Content-Type: application/json" -d '{"_id":"5fe8d4a319678cfd2ab2c6e2"}' localhost:8080/movies
""
```

Get a specific movie
```
$ curl localhost:8080/movie/5fe8d4a319678cfd2ab2c6e2
{"id":"5fe8d4a319678cfd2ab2c6e2","title":"Zodiac","watched":true,"year":2007}
```

Delete a movie
```
$ curl -XDELETE localhost:8080/movie/5fe8d41419678cfd2ab2c6e1
""
```