#!/bin/bash

# Expands environment variables in a text file.

perl -pe 's/\$(\w+)/$ENV{$1}/g' $1
