package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
)

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.GET("/", func(c *gin.Context) {
		name := c.Query("name")
		if name == "" {
			name = "Guest"
		}
		log.Printf("Received request for %s\n", name)
		c.String(http.StatusOK, "Hello, %s\n", name)
	})
	r.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "")
	})
	r.GET("/readiness", func(c *gin.Context) {
		c.String(http.StatusOK, "")
	})
	r.GET("/env/:env", func(c *gin.Context) {
		env := os.Getenv(c.Param("env"))
		c.String(http.StatusOK, env)
	})
	return r
}

func main() {

	r := setupRouter()
	port := os.Getenv("PORT")
	fmt.Printf("Got a PORT to use: " + port)
	srv := &http.Server{
		Handler:      r,
		Addr:         port,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	// Start Server
	go func() {
		log.Println("Starting Server")
		if err := r.Run("127.0.0.1:" + port); err != nil {
			log.Fatal(err)
		}
	}()

	// r.Run();
	// Graceful Shutdown
	waitForShutdown(srv)
}

func waitForShutdown(srv *http.Server) {
	interruptChan := make(chan os.Signal, 1)
	signal.Notify(interruptChan, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	// Block until we receive our signal.
	<-interruptChan

	// Create a deadline to wait for.
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()
	srv.Shutdown(ctx)

	log.Println("Shutting down")
	os.Exit(0)
}
