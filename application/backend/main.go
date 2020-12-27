package main

import (
	"context"
	"movie-app/db"
	"movie-app/handlers"

	"github.com/gin-gonic/gin"
)

func main() {

	// Create MongoDB Client
	db.Connect()
	// Disconnect client when main function stops running
	defer db.Client.Disconnect(context.Background())

	r := gin.Default()

	// Routes
	r.GET("/movies", handlers.GetAllMoviesHandler)
	r.GET("/movies/:id", handlers.GetMovieByIDHandler)
	r.POST("/movies", handlers.AddMovieHandler)
	r.DELETE("/movies/:id", handlers.DeleteMovieByIDHandler)
	r.PUT("/movies", handlers.WatchedMovieHandler)

	// listen and serve on 0.0.0.0:8080 and panics when error occurs.
	err := r.Run(":8080")
	if err != nil {
		panic(err)
	}
}
