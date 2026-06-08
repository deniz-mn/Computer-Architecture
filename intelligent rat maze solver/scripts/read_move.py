#!/usr/bin/env python3
"""
Convert binary direction codes to readable text format.
Usage: python read_move.py [input_file] [output_file]
"""

# Define the binary-to-direction mapping
direction_map = {
    '00': 'up',
    '01': 'right',
    '10': 'left',
    '11': 'down'
}

if __name__ == "__main__":
    import sys
    
    # Default file names
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    else:
        input_file = 'data/result/result.txt'
    
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    else:
        output_file = 'data/result/result_readable.txt'
    
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            code = line.strip()
            # Only translate if it's a valid direction
            if code in direction_map:
                outfile.write(direction_map[code] + '\n')
            else:
                # Write blank line or skip depending on what you want
                outfile.write('\n')  # Or just: pass
    
    print(f"Converted {input_file} to {output_file}")
