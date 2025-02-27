SRC_PATH ?= ../support
FULL_SRC_PATH = $(realpath $(SRC_PATH))

.PHONY: check clean build

check: $(FULL_SRC_PATH)/mul_arrays
	SRC_PATH=$(FULL_SRC_PATH) bash -c ./run_all_tests.sh

build $(FULL_SRC_PATH)/mul_arrays:
	make -s -C $(FULL_SRC_PATH)

clean:
	make -C $(FULL_SRC_PATH) clean
