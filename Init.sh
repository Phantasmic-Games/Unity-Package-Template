#!/bin/bash

if [ $# -eq 0 ]
    then
     read -p  'Organization Name:' ORGANIZATION_NAME
     ORGANIZATION_NAME=${ORGANIZATION_NAME//[^[:alnum:]]/}

     read -p 'Package Name:' PACKAGE_DISPLAY_NAME
    else
     ORGANIZATION_NAME=$1
     PACKAGE_DISPLAY_NAME=$2
fi

PACKAGE_NAME=${PACKAGE_DISPLAY_NAME//[^[:alnum:]]/}
FULL_NAME=$(echo "com.${ORGANIZATION_NAME}.${PACKAGE_NAME}" | tr '[:upper:]' '[:lower:]')

# Edit package.json
sed -i '' "s/com.organization.package/${FULL_NAME}/" package.json
sed -i '' "s/Package/${PACKAGE_DISPLAY_NAME}/" package.json

#Edit Asemdef files
sed -i '' "s/Package/${PACKAGE_NAME}/" Runtime/Organization.Package.asmdef
sed -i '' "s/Organization/${ORGANIZATION_NAME}/" Runtime/Organization.Package.asmdef

sed -i '' "s/Package/${PACKAGE_NAME}/g" Editor/Organization.Package.Editor.asmdef
sed -i '' "s/Organization/${ORGANIZATION_NAME}/g" Editor/Organization.Package.Editor.asmdef

mv Runtime/Organization.Package.asmdef Runtime/${ORGANIZATION_NAME}.${PACKAGE_NAME}.asmdef
mv Runtime/Organization.Package.asmdef.meta Runtime/${ORGANIZATION_NAME}.${PACKAGE_NAME}.asmdef.meta
         
mv Editor/Organization.Package.Editor.asmdef Editor/${ORGANIZATION_NAME}.${PACKAGE_NAME}.Editor.asmdef
mv Editor/Organization.Package.Editor.asmdef.meta Editor/${ORGANIZATION_NAME}.${PACKAGE_NAME}.Editor.asmdef.meta

#Clear README
echo "# ${PACKAGE_DISPLAY_NAME}" > README.md

#Delete .github
rm -rf .github