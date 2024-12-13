import subprocess
import glob

#Creating and writing header to usage file
file = open('usage.tsv', 'w')
file.write('Script Called\tFile Header\tAssembler\tExecution Time (s)\tCPU Usage\tMemory Usage\n')

# Close the file
file.close()

def assemble(assembler, file_list):
    # Run assembler on all three files
    for file in file_list:
        result = subprocess.run(
        ['TrackStats.sh', 'AssemblyCommands.sh' , assembler, file],
        capture_output=True,  # Capture both stdout and stderr
        text=True  # Treat the output as text
    )
    

# Setting up fastq file headers for use and running assembly script
assemblers = ['spades', 'skesa', 'megahit']
file_list = set()
matching_files = glob.glob('*.fastq.gz')
if matching_files:
    # Print the headers of all matching files
    for file_path in matching_files:
        file_path = file_path.rsplit('_', 1)[0]

        #print(f"Header of file '{file_path}':")
        file_list.add(file_path)
    file_list = list(file_list)

# Run assembly script
for assembler in assemblers:
    assemble(assembler, file_list)
