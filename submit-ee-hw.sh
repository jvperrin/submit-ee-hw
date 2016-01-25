#!/bin/bash

##########################################################
# Run this script in the same directory as your homework #
# files, and name the directory the same as the homework #
# you are submitting. For instance, for homework 0, name #
# the directory 'hw0'. If submitting self-grades, name   #
# the directory 'hw0_grades', like the assignment        #
# name being submitted on glookup.                       #
##########################################################

HW_NAME=$(basename "$PWD")
SERVER="cory.eecs.berkeley.edu"

read -p "What is your whole login? (e.g. ee16b-xxx) " EE_LOGIN

SSH_ADDR="$EE_LOGIN@$SERVER"

if [[ $HW_NAME == *"grades" ]]
then
  echo "Submitting self-grades!"

  echo "Uploading the grades to the instructional servers..."
  ssh $SSH_ADDR "mkdir -p ~/classes/ee16b/$HW_NAME"
  scp $HW_NAME.txt $SSH_ADDR:~/classes/ee16b/$HW_NAME/

else
  echo "Submitting a homework assignment!"

  # Ask about IPython submission
  while true; do
    read -p "Are you submitting a non-empty IPython notebook? (y/n) " yn
    case $yn in
      [Yy]* ) IPYNB=true; break;;
      [Nn]* ) IPYNB=false; break;;
      * ) echo "Please answer yes or no.";;
    esac
  done

  # Check first that the pdf does not already exist before creating it
  if [ ! -f "$HW_NAME.pdf" ]
  then
    echo "Making a pdf of the photos..."
    # Find all image files and convert them into a pdf
    convert $(find . -type f -exec file {} \; | awk -F: '{ if ($2 ~/image/) print $1}' | sort) uncompressed.pdf

    echo "Compressing the pdf..."
    pdf2ps uncompressed.pdf output.ps
    ps2pdf output.ps $HW_NAME.pdf
    rm uncompressed.pdf output.ps
  else
    echo "The pdf already exists, so no need to make it again"
  fi

  echo "Uploading the pdf to the instructional servers..."
  ssh $SSH_ADDR "mkdir -p ~/classes/ee16b/$HW_NAME"
  if [ "$IPYNB" = true ]
  then
    scp $HW_NAME.pdf $HW_NAME.ipynb $SSH_ADDR:~/classes/ee16b/$HW_NAME/
  else
    scp $HW_NAME.pdf $SSH_ADDR:~/classes/ee16b/$HW_NAME/
    ssh $SSH_ADDR "touch ~/classes/ee16b/$HW_NAME/$HW_NAME.ipynb"
  fi
fi

echo "Submitting documents to glookup..."
ssh $SSH_ADDR "
  cd ~/classes/ee16b/$HW_NAME
  submit $HW_NAME
  echo 'Submitted successfully! Time submitted:'
  glookup -t | grep $HW_NAME
"

