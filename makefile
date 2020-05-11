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
	build/bin/minecraft

fast:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=FALSE ..; make -j8)
	build/bin/minecraft

.PHONY: test
test:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Debug -DGTEST=TRUE ..; make -j8)
	build/bin/test

time:
	[ -d build ] || mkdir build
	(cd build; cmake -DCMAKE_BUILD_TYPE=Release -DGTEST=TRUE ..; make -j8)
	build/bin/test

gdb: build
	gdb -q -ex run --args build/bin/minecraft

clean:
	rm -rf build

.PHONY: profile
profile:
	valgrind --tool=callgrind build/bin/minecraft
	kcachegrind callgrind.out.*
	rm -f callgrind.out.*
