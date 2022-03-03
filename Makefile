
#VERSION is the commit id
VERSION ?= $(shell git describe --tags --always --dirty || echo "unknown")

IMAGE = saiteja313/apyc
IMAGE_NAME = $(IMAGE):$(VERSION)

all: unit-test build-docker push 

run:
	@echo "Running src/app.py. \n Tip: You can run app inside a docker container using 'make docker-run' \n"
	python src/app.py

unit-test:
	@echo "Running unit test. \n Tip: You can also run 'make docker-unit-test' to run unit tests using docker \n"
	python -m unittest tests/test_crawler.py

docker-build:
	docker build \
		-t "$(IMAGE_NAME)" \
		.
	@echo "Build complete for Docker image \"$(IMAGE_NAME)\""

docker-run:	docker-build
	@echo "Executing docker run -it \"$(IMAGE_NAME)\""
	docker run -it "$(IMAGE_NAME)"

docker-unit-test: docker-build
	docker run -it --entrypoint "" "$(IMAGE_NAME)" python -m unittest /opt/apyc/tests/test_crawler.py

# tag commit id as latest tag and push to docker hub.
docker-push: docker-unit-test
	docker tag "$(IMAGE_NAME)" "$(IMAGE)":latest
	docker push "$(IMAGE_NAME)"
	docker push "$(IMAGE_NAME)"
	@echo "Push successful for \"$(IMAGE_NAME)\""
	docker push "$(IMAGE)":latest
	@echo "Push successful for \"$(IMAGE_NAME)\":latest"
	@echo "push complete for Docker image \"$(IMAGE_NAME)\""

k8s-deploy:
	kubectl delete -f apyc-k8s-deployment.yml --ignore-not-found=true
	kubectl apply -f apyc-k8s-deployment.yml

clean:
	rm -f tests/__pycache__
	@echo "clean completed"
