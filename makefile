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
	docker build -t cocalc-base -f Dockerfile.quyo-01-base .

build-qsagemath:
	docker build -t cocalc-sagemath -f Dockerfile.quyo-02-sagemath .

build-qcocalc:
	docker build -t cocalc -f Dockerfile.quyo-03-cocalc .


build-full-qbase:
	docker build --no-cache -t cocalc-base -f Dockerfile.quyo-01-base .

build-full-qsagemath:
	docker build --no-cache -t cocalc-sagemath -f Dockerfile.quyo-02-sagemath .

build-full-qcocalc:
	docker build --no-cache -t cocalc -f Dockerfile.quyo-03-cocalc .
