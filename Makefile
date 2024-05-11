build:
	docker build . -t my-app-frontend
nocache: π
	docker build . -t my-app-frontend --no-cache
run:
	docker container run -p 8080:80 my-app-frontend:latest
plan:
	terraform -chdir="environments" plan
apply:
	terraform -chdir="environments" apply
destroy:
	terraform -chdir="environments" destroy
