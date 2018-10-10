#
# Makefile
# Malcolm Ramsay, 2018-10-10 11:58
#

all: present

.PHONY: install
install:
	npm install

.PHONY: present
present:
	./node_modules/.bin/remarker

.PHONY: build
build:
	./node_modules/.bin/remarker build



# vim:ft=make
#
