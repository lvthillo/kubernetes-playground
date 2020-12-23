package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func handleGetAllMovies(c *gin.Context) {
	var loadedMovies, err = GetAllMovies()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"msg": err})
		return
	}
	c.JSON(http.StatusOK, gin.H{"movies": loadedMovies})
}

func main() {
	r := gin.Default()
	//r.GET("/movies/:id", handleGetTask)
	r.GET("/movies/", handleGetAllMovies)
	//r.PUT("/tasks/", handleCreateTask)
	//r.POST("/tasks/", handleUpdateTask)
	r.Run() // listen and serve on 0.0.0.0:8080
}
