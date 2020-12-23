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