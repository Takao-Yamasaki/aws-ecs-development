build:
	docker build . -t my-app-frontend
nocache: 
	docker build . -t my-app-frontend --no-cache
run:
	docker container run -p 8080:80 my-app-frontend:latest
