#!/bin/bash

TABLE_BG_COLOR="#F6F8FA"

ARG1=$1

if [ "$ARG1" == "" ] ; then
  # If no filename, assume README.md
  ARG1="README.md"
fi

if [ ! -e "$ARG1" ] ; then
  echo -e "\nERROR: File \"$ARG1\" does not exist\n"
  exit
fi

if [ "${ARG1: -3}" != ".md" ] ; then
  echo -e "\nERROR: File \"$ARG1\" does not have the file extension .md\n"
  exit
fi

# Remove .md at the end
FILENAME="${ARG1::-3}"

echo "Converting file \"${FILENAME}.md\" to \"${FILENAME}.html\""

# The 'markdown' application only creates HTML code, it does not make the <HTML> <BODY> tags.
echo \
"<HTML>
<HEAD>
  <TITLE>${FILENAME}.html</TITLE>
</HEAD>
<BODY style=\"font-family: Arial\">
" > ${FILENAME}.html

# Convert markdown to HTML
markdown ${FILENAME}.md >> ${FILENAME}.html

# Put a horizontal rule after H1 and H2 tags
sed -i "s:</h1>:</h1><hr>:g" ${FILENAME}.html
sed -i "s:</h2>:</h2><hr>:g" ${FILENAME}.html

# Change blocks to have a gray background
sed -i "s:<pre>:<pre style=\"background-color\: $TABLE_BG_COLOR\">:g" ${FILENAME}.html
sed -i "s:<code>:<pre style=\"background-color\: $TABLE_BG_COLOR\">:g" ${FILENAME}.html
sed -i "s:</code>:</pre>:g" ${FILENAME}.html

#markdown ${FILENAME}.md > ${FILENAME}.html ; sed -i "s:<pre>:<pre style=\"background-color\: #F0F0F0\">:g" ${FILENAME}.html
#cp ${FILENAME}.md /tmp/${FILENAME}.md ; sed -i "s: :               :g" /tmp/${FILENAME}.md ; markdown /tmp/${FILENAME}.md > ${FILENAME}.html

# End the BODY and HTML tags
echo -e "
</BODY>
</HTML>
" >> ${FILENAME}.html



if [ "$1" == "numbering" ] ; then

  # Fix up numbering
  MAJOR=0
  MINOR=0
  echo -n "" > ${FILENAME}-2.md
  while IFS= read -r line; do

    #   ### 1. Text
    if [ "${line:0:4}" == "### " ] && [ "${line:5:1}" == "." ] ; then
       (( MAJOR = MAJOR + 1 ))
       MINOR=0
       echo "### ${MAJOR}. ${line:7}" >> ${FILENAME}-2.md
       continue
    fi

    #   ### 10. Text
    if [ "${line:0:4}" == "### " ] && [ "${line:6:1}" == "." ] ; then
       (( MAJOR = MAJOR + 1 ))
       MINOR=0
       echo "### ${MAJOR}. ${line:8}" >> ${FILENAME}-2.md
       continue
    fi

    #   #### 1.1 Text
    if [ "${line:0:5}" == "#### " ] && [ "${line:6:1}" == "." ] && [ "${line:8:1}" == " " ] ; then
       (( MINOR = MINOR + 1 ))
       echo "#### ${MAJOR}.${MINOR} ${line:9}" >> ${FILENAME}-2.md
       continue
    fi

    #   #### 1.10 Text
    if [ "${line:0:5}" == "#### " ] && [ "${line:6:1}" == "." ] && [ "${line:9:1}" == " " ] ; then
       (( MINOR = MINOR + 1 ))
       echo "#### ${MAJOR}.${MINOR} ${line:10}" >> ${FILENAME}-2.md
       continue
    fi

    echo "$line" >> ${FILENAME}-2.md

  done < ${FILENAME}.md

  rm ${FILENAME}.md
  mv ${FILENAME}-2.md ${FILENAME}.md

  markdown ${FILENAME}.md > ${FILENAME}.html
  sed -i "s:<pre>:<table width=\"50%\"><tr><td><pre style=\"background-color\: #F0F0F0\">:g" ${FILENAME}.html
  sed -i "s:<code>:<table width=\"50%\"><tr><td><pre style=\"background-color\: #F0F0F0\">:g" ${FILENAME}.html
  sed -i "s:</code>:</pre>:g" ${FILENAME}.html
  sed -i "s:</pre>:</pre></td></tr></table>:g" ${FILENAME}.html
fi


