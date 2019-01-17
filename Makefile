PWD=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

CMD=docker run --rm -p 4000:4000 -e PRIVATE_KEY -e API_URL -e BLOCKCHAIN_PROVIDER -e WRITE_MODE --network host -v $(PWD):/gitbook gitbook
FLAGS=--log=debug --debug

API_URL_PRODUCTION=https://achievement.network/api
API_URL_DEBUG=http://localhost:3000
BLOCKCHAIN_PROVIDER_PRODUCTION=https://ropsten.infura.io
BLOCKCHAIN_PROVIDER_DEBUG=http://127.0.0.1:7545

ifndef PRIVATE_KEY
$(error PRIVATE_KEY is not set)
endif

install:
	docker build -t gitbook $(PWD)
	docker run -v $(PWD):/gitbook gitbook bash -c "\
          mv book.json book.bak &&\
	  (grep -v -e exercises -e authentication book.bak > book.json);\
	  gitbook install;\
	  mv book.bak book.json;\
          mkdir node_modules/gitbook-plugin-exercises &&\
          cd node_modules/gitbook-plugin-exercises &&\
          git init &&\
          git remote add origin https://github.com/liquidity-network/plugin-exercises.git &&\
          git fetch --no-tags origin +refs/heads/master &&\
          git reset --hard origin/master &&\
          git submodule update --init --recursive &&\
	  npm install &&\
	  npm run build"

# @$(CMD) bash -c 'API_URL=$(API_URL_PRODUCTION) BLOCKCHAIN_PROVIDER=$(BLOCKCHAIN_PROVIDER_ROPSTEN) PRIVATE_KEY=$(PRIVATE_KEY) gitbook build ./'
build:
	@API_URL=$(API_URL_PRODUCTION) BLOCKCHAIN_PROVIDER=$(BLOCKCHAIN_PROVIDER_PRODUCTION) PRIVATE_KEY=$(PRIVATE_KEY) $(CMD) gitbook build ./

debug:
	API_URL=$(API_URL_DEBUG) BLOCKCHAIN_PROVIDER=$(BLOCKCHAIN_PROVIDER_DEBUG) PRIVATE_KEY=$(PRIVATE_KEY) $(CMD) gitbook serve $(FLAGS)

write:
	API_URL=$(API_URL_DEBUG) BLOCKCHAIN_PROVIDER=$(BLOCKCHAIN_PROVIDER_PRODUCTION) WRITE_MODE=true $(CMD) gitbook serve $(FLAGS)

all: install debug

clean:
	rm -fr _book
