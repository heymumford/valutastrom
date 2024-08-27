.PHONY: all java python js go rust r scala cpp verify

# Build all containers
all: java python js go rust r scala cpp verify

# Individual targets for each language
java:
	docker build -t javaHelloWorld ./src/java

python:
	docker build -t pythonHelloWorld ./src/python

js:
	docker build -t jsHelloWorld ./src/javascript

go:
	docker build -t goHelloWorld ./src/go

rust:
	docker build -t rustHelloWorld ./src/rust

r:
	docker build -t rHelloWorld ./src/r

scala:
	docker build -t scalaHelloWorld ./src/scala

cpp:
	docker build -t cppHelloWorld ./src/cpp

# Verify that containers are created successfully
verify:
	@docker images | grep -q javaHelloWorld && echo "Java container built successfully" || echo "Java container failed"
	@docker images | grep -q pythonHelloWorld && echo "Python container built successfully" || echo "Python container failed"
	@docker images | grep -q jsHelloWorld && echo "JavaScript container built successfully" || echo "JavaScript container failed"
	@docker images | grep -q goHelloWorld && echo "Go container built successfully" || echo "Go container failed"
	@docker images | grep -q rustHelloWorld && echo "Rust container built successfully" || echo "Rust container failed"
	@docker images | grep -q rHelloWorld && echo "R container built successfully" || echo "R container failed"
	@docker images | grep -q scalaHelloWorld && echo "Scala container built successfully" || echo "Scala container failed"
	@docker images | grep -q cppHelloWorld && echo "C++ container built successfully" || echo "C++ container failed"

