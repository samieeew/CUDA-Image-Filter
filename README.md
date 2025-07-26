# CUDA Image Filter - Sobel Edge Detection on Hand-Drawn Images

## Project Overview

This project implements a GPU-accelerated Sobel filter using CUDA to detect edges in grayscale images. A colored scene of a hand-drawn hut is generated using Python, converted to grayscale, and then processed using a CUDA kernel for edge detection. The goal is to demonstrate the benefits of GPU parallelism in image processing.

## Project Description

This project applies 2D image processing techniques on the GPU. Using CUDA, the program distributes the computation of the Sobel filter over a large number of threads to highlight edge regions in a grayscale image.

The Python script dynamically creates a test image resembling a hut, allowing for immediate testing without requiring external image assets. The project demonstrates basic GPU memory management, thread mapping to pixels, and visual output validation.

## Features

- CUDA-based Sobel edge detection
- Automatically generated test image (a simple colored hut drawing)
- Input conversion from RGB to grayscale (.pgm)
- Output images in both PGM and PNG formats
- Simple Makefile and Python tools for easy setup and execution

## Folder Structure

```

cuda-image-filter/
├── main.cu                   # CUDA implementation of Sobel filter
├── Makefile                  # For compiling and running
├── generate\_input\_image.py   # Generates the hut image (RGB and grayscale)
├── convert\_pgm\_to\_png.py     # Converts output.pgm to output.png
├── inputs/
│   ├── input\_rgb.png         # Colored input image
│   ├── input\_gray.png        # Grayscale preview
│   ├── input.pgm             # Grayscale input for CUDA
├── outputs/
│   ├── output.pgm            # Result from CUDA Sobel filter
│   ├── output.png            # PNG version for viewing
├── output.txt                # Execution log

````

## Requirements

- CUDA Toolkit (nvcc in PATH)
- Python 3.6 or later
- Python packages: `numpy`, `Pillow`

Install Python dependencies:

```bash
pip install numpy pillow
````

## How to Run

### Step 1: Generate Input Image

```bash
python3 generate_input_image.py
```

This creates:

* `inputs/input_rgb.png` – Colored image
* `inputs/input_gray.png` – Grayscale image preview
* `inputs/input.pgm` – Grayscale image used for CUDA input

### Step 2: Compile the CUDA Code

```bash
make
```

### Step 3: Run the Filter

```bash
make run
```

The Sobel filter is applied using CUDA, and the result is written to `outputs/output.pgm`. The output log is saved to `output.txt`.

### Step 4 (Optional): Convert Output to PNG

```bash
python3 convert_pgm_to_png.py
```

Creates `outputs/output.png` for easier viewing.



