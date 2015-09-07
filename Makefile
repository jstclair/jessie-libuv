NAME = jstclair/jessie-libuv

default: docker-build

docker-build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

run:
	docker run --rm -it $(NAME) bash
	
