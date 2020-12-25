package movie

import (
	"log"
	"movie-app/db"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Movie data structure
// each Movie struct will contain an ID, a Title and a Watched status.
// the second part of the struct shows how these 'fields' can be accessed in JSON.
type Movie struct {
	ID      primitive.ObjectID
	Title   string
	Year    int
	Watched bool
}

// GetAllMovies retrieves all movies from the db
func GetAllMovies() ([]*Movie, error) {
	var movies []*Movie

	collection := db.Conn.Database("movies").Collection("movies")
	cursor, err := collection.Find(db.Ctx, bson.D{})
	if err != nil {
		return nil, err
	}

	//defer cursor.Close(db.Ctx)

	err = cursor.All(db.Ctx, &movies)
	if err != nil {
		log.Printf("Failed marshalling %v", err)
		return nil, err
	}
	return movies, nil
}

// Add a movie to the db
func AddMovie(movie *Movie) (primitive.ObjectID, error) {
	movie.ID = primitive.NewObjectID()

	result, err := db.Conn.Database("movies").Collection("movies").InsertOne(db.Ctx, movie)
	if err != nil {
		log.Printf("Could not create movie: %v", err)
		return primitive.NilObjectID, err
	}
	oid := result.InsertedID.(primitive.ObjectID)
	return oid, nil
}
