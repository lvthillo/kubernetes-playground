package main

import "go.mongodb.org/mongo-driver/bson/primitive"

// Movie data structure
// each Movie struct will contain an ID, a Title and a Watched status.
// the second part of the struct shows how these 'fields' can be accessed in JSON.
type Movie struct {
	ID    primitive.ObjectID
	Title string
	Body  string
	//Watched bool
}
