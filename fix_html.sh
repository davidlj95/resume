#!/bin/bash
# Fixes some HTML when generating the resume
# and improves the printing of the document
# Constants
# FILE to fix
FILE="$1"
# 1. Page breaks
PAGE_BREAK_HTML="<div style=\"page-break-after: always\"></div>"
PAGE_BREAK_LINES=("<div class=\"detail\" id=\"work-experience\">" \
"<div class=\"detail\" id=\"skills\">" \
"<div class=\"detail\" id=\"education\">")
echo "Adding separators"
for break_line in "${PAGE_BREAK_LINES[@]}"; do
	echo " - Separator after $break_line"
	sed -i -e "s|$break_line|$PAGE_BREAK_HTML$break_line|" "$FILE"
done
