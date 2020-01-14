#!/bin/bash
# Name: export
# Description: Exports the JSON resume using JSONResume command line tools
#              https://jsonresume.org
# Usage: ./export.sh
# If you want to save a PDF file, please previously export a HTML to
# convert HTML to PDF properly (JSONResume sucks at this feature)
#
# Dependencies:
# You need wkhtmltopdf and http-server (NodeJS)
set -e

# Constants
RESUME_FILE="resume.json"
EXPORTS_FOLDER="./docs"
EXPORTS=("index.html" "davidlj95_Resume.pdf")
LATEST_HTML=""
THEME="material-design"

# Create exports folder
mkdir -p "$EXPORTS_FOLDER" &> /dev/null

# Compile
for file in "${EXPORTS[@]}"; do
	echo Exporting $file
	file_dest="$EXPORTS_FOLDER/$file"
	# HTML
	if [[ "$file" == *html ]]; then
		npx resume export --theme $THEME "$file_dest"
		LATEST_HTML="$file_dest"
	fi
	# PDF
	if [[ "$file" == *pdf ]]; then
		echo - Converting HTML to PDF
		echo - Launching webserver
		npx http-server "$(dirname "$LATEST_HTML")" &
		pid_http=$!
		sleep 2
		wkhtmltopdf --print-media-type --zoom 1 http://localhost:8080 "$EXPORTS_FOLDER/$file"
		kill $pid_http
		echo - Done
	fi
done
