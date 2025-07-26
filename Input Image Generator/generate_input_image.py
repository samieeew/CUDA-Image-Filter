import numpy as np
from PIL import Image, ImageDraw

def draw_colored_hut(width=256, height=256):
    image = Image.new("RGB", (width, height), "white")
    draw = ImageDraw.Draw(image)

    draw.rectangle([80, 130, 180, 220], fill="saddlebrown", outline="black")

    draw.polygon([ (80,130), (180,130), (130,70) ], fill="darkred", outline="black")

    draw.rectangle([115, 170, 145, 220], fill="peru", outline="black")

    image.save("inputs/input_rgb.png")
    image.save("inputs/input_rgb.ppm")  

    return image

def convert_to_grayscale(image_rgb):
  
    gray = image_rgb.convert("L")
    gray.save("inputs/input.pgm")        
    gray.save("inputs/input_gray.png")   

    print("Generated grayscale input.pgm and PNG")

if __name__ == "__main__":
    rgb_image = draw_colored_hut()
    convert_to_grayscale(rgb_image)
    print(" Hut image generated in inputs/ folder.")
