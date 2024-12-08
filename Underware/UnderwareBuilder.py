import subprocess
import os
import sys
import concurrent.futures
import itertools

# Specify the path to openscad.exe
openscad_path = 'C:/Program Files/OpenSCAD (Nightly)/openscad.exe'

# Check if openscad.exe exists
if not os.path.isfile(openscad_path):
    print(f"Error: openscad.exe not found at {openscad_path}")
    sys.exit(1)


# I Channel Variables
# Define the range of numbers
lengths = range(1, 6)

# Define the string parameter
mounting_type = "Threaded Snap Connector"

# Define the output directory
output_dir = 'Output3MF'

# Create the directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Add variables for parallel processing
parallel = True
num_processes = 10

# Define widths
widths = range(1, 4)

def generate_output(args):
    length, width = args
    # Construct the command
    output_file = os.path.join(output_dir, f'i_Channel_len{length}_width{width}_{mounting_type}.3mf')
    command = [
        openscad_path,
        '-o', output_file,
        '-D', f'Channel_Length_Units={length}',
        '-D', f'Channel_Width_in_Units={width}',
        '-D', f'Mounting_Method="{mounting_type}"',
        'Underware_I_Channel.scad'
    ]
    # Call openscad.exe and handle errors
    try:
        subprocess.run(command, check=True)
        print(f"Generated {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error generating {output_file}: {e}")
        sys.exit(1)

if __name__ == "__main__":
    combinations = list(itertools.product(lengths, widths))
    # Modify the loop to run in parallel if enabled
    if parallel:
        with concurrent.futures.ProcessPoolExecutor(max_workers=num_processes) as executor:
            executor.map(generate_output, combinations)
    else:
        for args in combinations:
            generate_output(args)
