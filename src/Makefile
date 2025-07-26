# Makefile for CUDA Sobel Filter Project

NVCC := nvcc
TARGET := sobel
SRC := main.cu
OUT := output.txt

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) -o $(TARGET) $(SRC)

run: $(TARGET)
	./$(TARGET) inputs/input.pgm outputs/output.pgm | tee $(OUT)

clean:
	rm -f $(TARGET) $(OUT)
