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
# 2. Export as PDF button
# # CSS Style
read -r -d '' EXPORT_CSS <<- EOF
<style>
@media print { div.export { display: none; } }
div.export {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 100;
    background-color: rgba(127, 127, 127, 0.85);
    padding: 1.5em;
    border-radius: 1.5em;
    margin: 2em 2em 0 0;
}

div.export img {
    height: 4em;
}

a.export {
    color: white;
    font-weight: bold;
    font-size: 1em;
    text-decoration: none;
}

@media screen and (max-width:625px) {
    div.export {
        margin: 1em 1em;
        padding: 0.75em;
    }
    div.export span {
        display: none;
    }
}
</style>
EOF
# Delete new lines
EXPORT_CSS=$(echo $EXPORT_CSS)
echo "Adding \"Export as PDF\" CSS code"
sed -i -e "s|</style>|</style>$EXPORT_CSS|" "$FILE"
# # HTML code
read -r -d '' EXPORT_HTML <<- EOF
<a class="export" href="davidlj95_Resume.pdf" download>
        <div class="export">
            <img src="https://i.imgur.com/ava66Iu.png" />
            <span>Download as PDF</span>
        </div>
    </a>
EOF
# Delete new lines
EXPORT_HTML=$(echo $EXPORT_HTML)
EXPORT_HTML_PLACE="<body itemscope=\"itemscope\" itemtype=\"http://schema.org/Person\">"
echo "Adding \"Export as PDF\" HTML code"
sed -i -e "s|$EXPORT_HTML_PLACE|$EXPORT_HTML_PLACE$EXPORT_HTML|" "$FILE"
