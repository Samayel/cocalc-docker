build:
	docker build -t cocalc .

build-full:
	docker build --no-cache -t cocalc .

light:
	docker build -t cocalc-light -f Dockerfile-light .

run:
	mkdir -p data/projects && docker run --name=cocalc-light -d -p 443 -p 80:80 -v `pwd`/data/projects:/projects -P cocalc
	
run-light:
	mkdir -p data/projects-light && docker run --name=cocalc-light -d -p 443:443 -p 80:80 -v `pwd`/data/projects:/projects -P cocalc-light


build-qbase:
	DOCKER_BUILDKIT=0 docker build -t quyo/cocalc-base:dev -f Dockerfile.quyo-01-base .

build-qsagemath:
	DOCKER_BUILDKIT=0 docker build -t quyo/cocalc-sagemath:dev -f Dockerfile.quyo-02-sagemath .

build-qcocalc:
	DOCKER_BUILDKIT=0 docker build -t quyo/cocalc:dev -f Dockerfile.quyo-03-cocalc .


build-full-qbase:
	DOCKER_BUILDKIT=0 docker build --no-cache -t quyo/cocalc-base:dev -f Dockerfile.quyo-01-base .

build-full-qsagemath:
	DOCKER_BUILDKIT=0 docker build --no-cache -t quyo/cocalc-sagemath:dev -f Dockerfile.quyo-02-sagemath .

build-full-qcocalc:
	DOCKER_BUILDKIT=0 docker build --no-cache -t quyo/cocalc:dev -f Dockerfile.quyo-03-cocalc .
