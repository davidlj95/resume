# Signs the PDF CV
# ------------------------------------------------------------------------------
# In order to work, please make sure you have a sign.env file containing all
# required variable. See example for more information about the vars to declare
#
# Example:
# keystore_file=/home/user/certificate.p12
# keystore_type=PKCS12
# # keystore_types=check with $JSIGNPDF -lkt
# contact=me@example.org
# location=Washington DC, USA
# # Constants
JSIGNPDF="java -jar /opt/jsignpdf/current/JSignPdf.jar"
SIGN_FILE="./docs/davidlj95_Resume.pdf"
EXTENSION="${SIGN_FILE##*.}"
SUFFIX="_signed"
SIGNED_FILE="${SIGN_FILE%.*}$SUFFIX.$EXTENSION"
VAR_FILE="sign.env"
# # Load more constants
source "$VAR_FILE"
# # Options
OPTIONS="$OPTIONS --contact \"$contact\""
OPTIONS="$OPTIONS --location \"$location\""
OPTIONS="$OPTIONS --certification-level CERTIFIED_NO_CHANGES_ALLOWED"
OPTIONS="$OPTIONS --disable-assembly --disable-copy --disable-fill --disable-modify-annotations"
OPTIONS="$OPTIONS --disable-modify-content"
OPTIONS="$OPTIONS --encryption PASSWORD"
OPTIONS="$OPTIONS --out-directory ./docs"
OPTIONS="$OPTIONS --hash-algorithm SHA512"
OPTIONS="$OPTIONS --keystore-file $keystore_file"
OPTIONS="$OPTIONS --keystore-type $keystore_type"
OPTIONS="$OPTIONS --out-suffix \"$SUFFIX\""
OPTIONS="$OPTIONS --tsa-authentication NONE"
OPTIONS="$OPTIONS --tsa-server-url https://freetsa.org/tsr"
OPTIONS="$OPTIONS --tsa-hash-algorithm SHA512"
# Run
echo "Signing PDF file \"$SIGN_FILE\""
# # File exists
if test ! -r "$SIGN_FILE" -o ! -f "$SIGN_FILE"; then
	echo "File to sign not found"
	exit 5
fi
# # Questions
read -s -p "  Type your keystore file password: " keystore_password
OPTIONS="$OPTIONS --keystore-password \"$keystore_password\""
echo
read -s -p "  Type your password to protected signed PDF rights: " owner_password
OPTIONS="$OPTIONS --owner-password \"$owner_password\""
echo
# # Do the sign
$JSIGNPDF $SIGN_FILE $OPTIONS
sign_exit_code=$?
# # Check if OK
case $sign_exit_code in
    0)
	# Finished properly
	echo "Success signing"
	# Open
	xdg-open "$SIGNED_FILE"
	# Replace
	while true; do
	    read -p "  Do you want to replace signed by original one?: " yn
	    case $yn in
	        [Yy]* ) mv "$SIGNED_FILE" "$SIGN_FILE"; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
	;;
    1) echo "Wrong command line";;
    2) echo "No operation requested";;
    3) echo "Signing of some files failed";;
    4) echo "Signing of all files failed";;
esac
echo "Finished signing"
exit $sign_exit_code
