# XDMA HAL Library Makefile

AR := ar
CXX := xcpp
CXX_EXT := cpp
CXXFLAGS :=  -Werror -std=c++11
ARFLAGS := rv
STLIB := libxclgemdrv.a
SHLIB := libxclgemdrv.so
XCLHAL_VER =-DXCLHAL_MAJOR_VER=1 -DXCLHAL_MINOR_VER=1 #-DXCLHAL2=1

SHIM_INC := -I../../../ -I../include -I../../include \
            -I../include/FPGA_management_lib
CXXFLAGS += $(CXXFLAGS) $(XCLHAL_VER) $(SHIM_INC) -fpic -fvisibility=hidden -lrt

ifeq ($(debug),1)
	CXXFLAGS += -g -DDEBUG
else
	CXXFLAGS += -O2 -DNDEBUG
endif

SRCS := $(wildcard *.$(CXX_EXT))
OBJS := $(patsubst %.$(CXX_EXT), %.o, $(SRCS))

-include $(OBJS:.o=.d)

all: $(STLIB) $(SHLIB)
	rm -rf ../../../../../lib/runtime/platforms/hal/driver/*
	cp -rf ./libxclgemdrv.so ../../../../../lib/runtime/platforms/hal/driver/
	cp -rf ./libxclgemdrv.a ../../../../../lib/runtime/platforms/hal/driver/

clean:
	rm -rf *.o *.d $(STLIB) $(SHLIB)

%.o: %.$(CXX_EXT)
	$(CXX) $(CXXFLAGS) $(MYCFLAGS) -c $< -o $@
	$(CXX) $(CXXFLAGS) $(MYCFLAGS) -c -MM $< -o $(patsubst %.o, %.d, $@)

$(SHLIB) : $(OBJS)
	$(CXX) -shared -fPIC -o $@ $^

$(STLIB) : $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

.PHONY: all clean

.DEFAULT_GOAL := all
