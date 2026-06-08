import matplotlib.pyplot as plt
import numpy as np

def visualize_grid(grid):
    # Define color mapping: 0 -> green, 1 -> red
    color_map = {
        0: [0.0, 1.0, 0.0],  # green
        1: [1.0, 0.0, 0.0]   # red
    }

    # Convert the binary grid to RGB colors
    rgb_grid = np.array([[color_map[val] for val in row] for row in grid], dtype=float)

    fig, ax = plt.subplots()
    ax.imshow(rgb_grid)

    # Set grid lines
    ax.set_xticks(np.arange(-0.5, 16, 1), minor=True)
    ax.set_yticks(np.arange(-0.5, 16, 1), minor=True)
    ax.grid(which='minor', color='black', linewidth=1)
    
    # Hide major ticks
    ax.set_xticks([])
    ax.set_yticks([])
    ax.tick_params(which='both', bottom=False, left=False)

    plt.title("Home Grid (Green = 0, Red = 1)")
    plt.show()

def read_grid_from_file(filename="data/maps/map_0.txt"):
    grid = []
    with open(filename, 'r') as f:
        lines = f.readlines()
        if len(lines) != 16:
            raise ValueError("The file must contain exactly 16 lines.")
        for line in lines:
            line = line.strip()
            if len(line) != 16 or any(c not in "01" for c in line):
                raise ValueError("Each line must be exactly 16 characters of 0 or 1.")
            grid.append([int(c) for c in line])
    return grid

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        filename = sys.argv[1]
    else:
        filename = "data/maps/map_0.txt"
    grid = read_grid_from_file(filename)
    visualize_grid(grid)
