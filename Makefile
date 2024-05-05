build:
	docker build --platform linux/x86_64 -t my-app-frontend
run:
	docker contaner run -p 8080:80
