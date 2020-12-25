package db

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

const (
	connectionStringTemplate = "mongodb://%s:%s@%s"
)

var (
	Conn *mongo.Client
	Ctx  context.Context
)

// Connect with create the connection to MongoDB
func Connect() {
	username := os.Getenv("MONGODB_USERNAME")
	password := os.Getenv("MONGODB_PASSWORD")
	clusterEndpoint := os.Getenv("MONGODB_ENDPOINT")

	connectionURI := fmt.Sprintf(connectionStringTemplate, username, password, clusterEndpoint)

	context, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	//context, cancel := context.WithTimeout(context.Background(), connectTimeout*time.Second)
	defer cancel()

	client, err := mongo.NewClient(options.Client().ApplyURI(connectionURI))
	if err != nil {
		log.Printf("Failed to create client: %v", err)
	}

	err = client.Connect(context)
	if err != nil {
		log.Printf("Failed to connect to cluster: %v", err)
	}
	//defer client.Disconnect(context)

	// Force a connection to verify our connection string
	err = client.Ping(context, nil)
	if err != nil {
		log.Printf("Failed to ping cluster: %v", err)
	}

	Conn = client
	Ctx = context

	log.Printf("Connected to MongoDB!")
}
