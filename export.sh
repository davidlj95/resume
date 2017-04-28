#!/bin/bash
# Name: export
# Description: Exports the JSON resume using JSONResume command line tools
#              https://jsonresume.org

# Constants
RESUME_FILE="resume.json"
EXPORTS_FOLDER="./docs"
EXPORTS=("davidlj95_Resume.pdf" "index.html")
THEME="elegant"

# Create exports folder
mkdir "$EXPORTS_FOLDER" &> /dev/null

# Compile
for file in ${EXPORTS[@]}; do
	echo $file
	resume export --theme $THEME "$EXPORTS_FOLDER/$file"
done
