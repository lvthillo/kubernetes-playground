package main

import (
	"movie-app/db"
	"movie-app/handlers"

	"github.com/gin-gonic/gin"
)

//func init() {
//	db.Connect()
//}

func main() {

	// Configure
	db.Connect()
	r := gin.Default()

	// Routes
	r.GET("/movies", handlers.GetAllMoviesHandler)
	r.POST("/movies", handlers.AddMovieHandler)

	// listen and serve on 0.0.0.0:8080
	r.Run()
}
