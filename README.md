# Data-Discovery
This script is designed to perform a data discovery scan on a user's home directory and its subdirectories. The script is divided into several sections, each with a specific purpose. It is intended to be executed on Trend Micro XDR through its automated response workflow.

The script begins by defining several variables. The `USER_HOME` variable is set to the home directory of the user. The `DIRECTORIES` array is populated with the paths of specific directories to scan. The `KEYWORDS` array contains keywords to search for in file names and contents. The `FILE_TYPES` and `CONTENT_FILE_TYPES` arrays define the file types to search for based on file names and contents, respectively. The `total_files_found` variable is initialized to keep track of the total number of files found, and the `file_paths` array is initialized to store the paths of the found files. The `hostname` variable is set to the hostname of the machine.

The `search_files` function is defined to search for files in the specified directories. It iterates over each directory in the `DIRECTORIES` array, checks if the directory exists, and then iterates over each keyword and file type to search for files whose names contain the keyword and match the file type. For each file found, it prints the file path, detailed information about the file, and the file contents (unless it's a binary file). It also increments the `total_files_found` counter and stores the file path in the `file_paths` array.

The `list_directories` function is defined to list the files in each directory in the `DIRECTORIES` array. It iterates over each directory, checks if the directory exists, and then lists the files in the directory.

The `main` function is defined to perform the search and display a summary of the search results. It calls the `search_files` function, gets the current timestamp, extracts the username from `USER_HOME`, converts the arrays to comma-separated strings for the summary message, and then prints the summary. The summary includes the hostname, username, timestamp, keywords used, file types focused on, total number of files found, and paths of the files found.

The script ends by calling the `list_directories` function to list the files in the directories, and then calling the `main` function to execute the search.

This script could be improved by adding error handling to account for potential issues such as inaccessible directories or files. Additionally, the output could be formatted in a more readable way, such as by using tables or indentation to clearly separate different pieces of information.
