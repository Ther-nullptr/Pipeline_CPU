with open('hex_2.txt') as f:
    for i,line in enumerate(f):
        print(f"RAM_data[10'd{i}] <= 32'd{line.strip()};")