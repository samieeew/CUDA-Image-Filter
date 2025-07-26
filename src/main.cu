#include <cuda_runtime.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

#define CHECK_CUDA(call)                                                   \
    {                                                                      \
        cudaError_t err = call;                                            \
        if (err != cudaSuccess) {                                          \
            std::cerr << "CUDA error at " << __FILE__ << ":" << __LINE__  \
                      << ": " << cudaGetErrorString(err) << std::endl;    \
            exit(EXIT_FAILURE);                                            \
        }                                                                  \
    }

__global__ void sobelFilter(const unsigned char* input, unsigned char* output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= width || y >= height) return;

    int Gx[3][3] = {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };

    int Gy[3][3] = {
        {-1, -2, -1},
        { 0,  0,  0},
        { 1,  2,  1}
    };

    if (x > 0 && y > 0 && x < width - 1 && y < height - 1) {
        int gx = 0, gy = 0;

        for (int i = -1; i <= 1; ++i)
            for (int j = -1; j <= 1; ++j) {
                int pixel = input[(y + i) * width + (x + j)];
                gx += Gx[i + 1][j + 1] * pixel;
                gy += Gy[i + 1][j + 1] * pixel;
            }

        int mag = sqrtf(gx * gx + gy * gy);
        output[y * width + x] = min(255, mag);
    } else {
        output[y * width + x] = 0;
    }
}

void readPGM(const std::string& filename, std::vector<unsigned char>& data, int& width, int& height) {
    std::ifstream file(filename, std::ios::binary);
    std::string line;
    file >> line; // P5
    file >> width >> height;
    int maxVal;
    file >> maxVal;
    file.ignore(256, '\n');
    data.resize(width * height);
    file.read(reinterpret_cast<char*>(data.data()), width * height);
}

void writePGM(const std::string& filename, const std::vector<unsigned char>& data, int width, int height) {
    std::ofstream file(filename, std::ios::binary);
    file << "P5\n" << width << " " << height << "\n255\n";
    file.write(reinterpret_cast<const char*>(data.data()), width * height);
}

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "Usage: ./sobel input.pgm output.pgm\n";
        return 1;
    }

    int width, height;
    std::vector<unsigned char> input;
    readPGM(argv[1], input, width, height);

    std::vector<unsigned char> output(width * height);

    unsigned char *d_input, *d_output;
    size_t imageSize = width * height * sizeof(unsigned char);

    CHECK_CUDA(cudaMalloc(&d_input, imageSize));
    CHECK_CUDA(cudaMalloc(&d_output, imageSize));
    CHECK_CUDA(cudaMemcpy(d_input, input.data(), imageSize, cudaMemcpyHostToDevice));

    dim3 blockSize(16, 16);
    dim3 gridSize((width + 15) / 16, (height + 15) / 16);

    sobelFilter<<<gridSize, blockSize>>>(d_input, d_output, width, height);
    CHECK_CUDA(cudaDeviceSynchronize());

    CHECK_CUDA(cudaMemcpy(output.data(), d_output, imageSize, cudaMemcpyDeviceToHost));

    writePGM(argv[2], output, width, height);

    CHECK_CUDA(cudaFree(d_input));
    CHECK_CUDA(cudaFree(d_output));

    std::cout << "Sobel filter applied successfully.\n";
    return 0;
}
