build:
	docker build . -t my-app-frontend
nocache:
	docker build . -t my-app-frontend --no-cache
run:
	docker container run -p 8080:80 my-app-frontend:latest
plan:
	terraform -chdir="environments" plan
apply:
	terraform -chdir="environments" apply
destroy:
	terraform -chdir="environments" destroy
inframap:
	inframap generate ./environments/ | dot -Tpng > inframap_generate.png
graph:
	terraform -chdir="environments" graph -type=plan | dot -Tpng >graph.png
