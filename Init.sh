#!/bin/bash

# Ask for Organization and Package names if they weren't provided
if [ $# -eq 0 ]
    then
     read -p  'Organization Name:' ORGANIZATION_NAME
     read -p 'Package Name:' PACKAGE_DISPLAY_NAME
    else
     ORGANIZATION_NAME=$1
     PACKAGE_DISPLAY_NAME=$(echo $2 | tr '-' ' ')
fi

ORGANIZATION_NAME=${ORGANIZATION_NAME//[^[:alnum:]]/}
PACKAGE_NAME=${PACKAGE_DISPLAY_NAME//[^[:alnum:]]/}
FULL_NAME=$(echo "com.${ORGANIZATION_NAME}.${PACKAGE_NAME}" | tr '[:upper:]' '[:lower:]')

# Edit package.json.
sed -i.bak "s/com.organization.package/${FULL_NAME}/" package.json
sed -i.bak "s/Package/${PACKAGE_DISPLAY_NAME}/" package.json

# Assign Organization and Pacakge names in asmdef files.
find . -name "*.asmdef" -exec sed -i.bak "s/Package/${PACKAGE_NAME}/g" {} \;
find . -name "*.asmdef" -exec sed -i.bak "s/Organization/${ORGANIZATION_NAME}/g" {} \;

# Rename assembly definition files and their .meta files
for f in */*.asmdef* ; do mv $f $(echo "${f/Organization.Package/${ORGANIZATION_NAME}.${PACKAGE_NAME}}") ; done;

# Based off of https://gist.github.com/markusfisch/6110640
function guid()
{
	local N B C='89ab'

	for (( N=0; N < 16; ++N ))
	do
		B=$(( $RANDOM%256 ))

		case $N in
			6)
				printf '4%x' $(( B%16 ))
				;;
			8)
				printf '%c%x' ${C:$RANDOM%${#C}:1} $(( B%16 ))
				;;
			3 | 5 | 7 | 9)
				printf '%02x' $B
				;;
			*)
				printf '%02x' $B
				;;
		esac
	done

	echo
}

# Give all meta files new GUIDs
for f in *.meta */*.meta ; do
    sed -i.bak -e "2s/.*/guid: $(guid)/" $f
done

# Clear README
echo "# ${PACKAGE_DISPLAY_NAME}" > README.md

# Delete .github folder
rm -rf .github

# Delete generated .bak files
find . -name "*.bak" -type f -delete

echo "Package is Initialized"

#Deletes itself
rm -- "$0"