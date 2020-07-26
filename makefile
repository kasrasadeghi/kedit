default: fast

execname=$(shell basename "$(shell pwd)")

todo:
	(cd docs; make)

compile:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=FALSE ..; make -j8)

release:
	rm -rf build
	mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=FALSE ..; make -j8)

.PHONY: build
build:
	rm -rf build
	mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Debug -DGTEST=FALSE ..; scan-build -V make -j8)

run:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Debug -DGTEST=FALSE ..; make -j8)
	bin/$(execname)

fast:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=FALSE ..; make -j8)
	bin/$(execname)

.PHONY: test
test:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Debug -DGTEST=TRUE ..; make -j8)
	bin/test

time:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=TRUE ..; make -j8)
	bin/test

gdb: build
	gdb -q -ex run --args bin/$(execname)

clean:
	rm -rf build

install: release
	cp bin/kedit ~/bin/kedit
	[ -d ~/bin/fonts ] || mkdir ~/bin/fonts
	cp fonts/SourceCodePro-Regular.ttf ~/bin/fonts

.PHONY: profile
profile:
	valgrind --tool=callgrind bin/$(execname)
	kcachegrind callgrind.out.*
	rm -f callgrind.out.*
