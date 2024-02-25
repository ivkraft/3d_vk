VULKAN_SDK_PATH = /Users/wizz/VulkanSDK/1.3.268.1/macOS
BREW_PATH = /opt/homebrew
GLSLC = /usr/local/bin/glslc

CFLAGS = -std=c++17 -I. -I$(VULKAN_SDK_PATH)/include -I$(BREW_PATH)/include 
LDFLAGS = -L$(VULKAN_SDK_PATH)/lib -L$(BREW_PATH)/lib `pkg-config --static --libs glfw3` -lvulkan


vertSources = $(shell find ./shaders -type f -name "*.vert")
vertObjFiles = $(patsubst %.vert, %.vert.spv, $(vertSources))
fragSources = $(shell find ./shaders -type f -name "*.frag")
fragObjFiles = $(patsubst %.frag, %.frag.spv, $(fragSources))

TARGET = a.out
$(TARGET): $(vertObjFiles) $(fragObjFiles)
${TARGET}: *.cpp *.hpp
	g++ $(CFLAGS) -o ${TARGET} *.cpp $(LDFLAGS)

# make shader targets
%.spv: %
	${GLSLC} $< -o $@

.PHONY: test clean

test: ${TARGET}
	DYLD_LIBRARY_PATH=$(VULKAN_SDK_PATH)/lib VK_LAYER_PATH=$(VULKAN_SDK_PATH)/share/vulkan/explicit_layer.d ./${TARGET}

clean:
	rm -f ${TARGET}
	rm -f shaders/*.spv
	