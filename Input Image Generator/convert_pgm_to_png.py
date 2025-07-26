from PIL import Image

def convert_pgm_to_png(input_path, output_path):
    image = Image.open(input_path)
    image.save(output_path)
    print(f"Converted: {input_path} → {output_path}")

if __name__ == "__main__":
    convert_pgm_to_png("outputs/output.pgm", "outputs/output.png")
