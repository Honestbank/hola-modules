FROM golang:latest as builder

# Set the Current Working Directory inside the container
#WORKDIR $GOPATH/src/github.com/jai/hola-mundo
WORKDIR /app

# Copy everything from the current directory to the PWD (Present Working Directory) inside the container
COPY . .

# Download all the dependencies
#RUN go get -d -v ./...

# Install the package
#RUN go install -v ./...

# This container exposes port 8080 to the outside world
EXPOSE 8080

# Run the executable
# Need to have option `CGO_ENABLED=0` and `-installsuffix cgo` because `alpine` need these tags in order for it to run
# If not provided the excution will say `standard_init_linux.go:211: exec user process caused "no such file or directory"`
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hola-modules .

######## Start a new stage from scratch #######
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/hola-modules .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./hola-modules"]
