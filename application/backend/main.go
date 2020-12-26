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

	// listen and serve on 0.0.0.0:8080
	r.Run()
}
