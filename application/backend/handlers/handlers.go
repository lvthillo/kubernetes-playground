package handlers

import (
	"log"
	"movie-app/movie"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetAllMoviesHandler to get all movies
func GetAllMoviesHandler(c *gin.Context) {
	var loadedMovies, err = movie.GetAllMovies()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"msg": err})
		return
	}
	c.JSON(http.StatusOK, gin.H{"movies": loadedMovies})
}

// AddMovieHandler to add a movie
func AddMovieHandler(c *gin.Context) {
	var mov movie.Movie
	if err := c.ShouldBindJSON(&mov); err != nil {
		log.Print(err)
		c.JSON(http.StatusBadRequest, gin.H{"msg": err})
		return
	}
	id, err := movie.AddMovie(&mov)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"msg": err})
		return
	}
	c.JSON(http.StatusOK, gin.H{"id": id})
}
