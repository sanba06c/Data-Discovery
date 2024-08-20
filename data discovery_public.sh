#!/bin/bash

# Define the user's home directory explicitly, replace <username> with the actual username
USER_HOME="/Users/<username>"

# Define the specific directories to scan
DIRECTORIES=(
 "$USER_HOME/Downloads"
 "$USER_HOME/Documents"
 "$USER_HOME/Desktop"
 "$USER_HOME/Music"
 "$USER_HOME/Pictures"
 "$USER_HOME/Public"
 "$USER_HOME/Library/CloudStorage/"
 "$USER_HOME/Videos"
 "$USER_HOME/Templates"
 "$USER_HOME/.config"
 "$USER_HOME/.local"
 "$USER_HOME/.cache"
 "$USER_HOME/.ssh"
 "$USER_HOME/.npm"
 "$USER_HOME/.docker"
)

# Define the keywords for file names and contents, adjust as needed
KEYWORDS=("credit card" "secret" "api")

# Define the file types for name-based search, adjust as needed
FILE_TYPES=("*.exe" "*.doc" "*.docx" "*.txt" "*.zip")

# Define the file types to be checked for content keywords, adjust as needed
CONTENT_FILE_TYPES=("*.exe" "*.doc" "*.docx" "*.txt" ".zip")

# Initialize a counter for the total number of files found
total_files_found=0
# Initialize an array to hold file paths for the summary
file_paths=()

# Define the hostname
hostname=$(hostname)

# Function to search for file names and types in specific directories
search_files() {
  for dir in "${DIRECTORIES[@]}"; do
    if [ -d "$dir" ]; then
      echo "Scanning directory: \"$dir\""
      for keyword in "${KEYWORDS[@]}"; do
        for type in "${FILE_TYPES[@]}"; do
          echo "Searching for files with name containing '$keyword' and type '$type' in \"$dir\"..."
          # Use find to list files, and process each file found
          while IFS= read -r -d '' file; do
            echo "File found: $file"
            # Print detailed information about each file
            ls -lh "$file"
            # Read the contents of each found file
            if [[ "$file" == *.exe ]]; then
              echo "Binary file, contents not displayed."
            else
              echo "Contents of $file matching keywords:"
              cat "$file"
            fi
            echo "---------------------------"
            # Increment the total files found counter
            ((total_files_found++))
            # Store the file path in the array
            file_paths+=("$file")
          done < <(find "$dir" -type f -iname "*$keyword*" -iname "$type" -print0)
        done
      done
      # Additionally search specific file types in the directory for content keywords
      echo "Searching for content keywords in specific file types in \"$dir\"..."
      for type in "${CONTENT_FILE_TYPES[@]}"; do
        grep -ril "${KEYWORDS[*]}" "$dir" --include="$type" | while IFS= read -r file; do
          echo "File found by content: $file"
          ls -lh "$file"
          echo "Contents of $file matching keywords:"
          grep -i "${KEYWORDS[*]}" "$file"
          echo "---------------------------"
          ((total_files_found++))
          file_paths+=("$file")
        done
      done
    else
      echo "Directory \"$dir\" does not exist."
    fi
  done
}

# Function to list files in the specified directories
list_directories() {
  for dir in "${DIRECTORIES[@]}"; do
    if [ -d "$dir" ]; then
      echo "Listing files in directory: \"$dir\""
      ls -lh "$dir"
      echo "---------------------------"
    else
      echo "Directory: \"$dir\" does not exist."
    fi
  done
}

# Main function to perform the search and display summary
main() {
  echo "Starting file search..."
  search_files
  echo "Search complete."
  
  # Get the current timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Extract the username from USER_HOME, replace <username> with the actual username
  USER_HOME="/Users/<username>"
  username=$(basename "$USER_HOME")
  
  # Convert arrays to comma-separated strings for the summary message
  keywords_str=$(IFS=, ; echo "${KEYWORDS[*]}")
  file_types_str=$(IFS=, ; echo "${FILE_TYPES[*]}")
  
  echo "Summary: The scan of offboarded  project on the hostname $hostname of the user '$username' was conducted by the InfoSec team at $timestamp. The predefined criteria combined between keywords '$keywords_str' and file types '$file_types_str' were used during the scan, focusing on the user's typical storage directories. The results are as follows:"
  echo "Total files found: $total_files_found"
  if [ "$total_files_found" -gt 0 ]; then
    echo "Files found:"
    for file in "${file_paths[@]}"; do
      echo "$file"
    done
  else
    echo "No files matching the given criteria were found."
  fi
}

# Call the function to list files
echo "Listing files in the directories..."
list_directories
# Execute the main function
main