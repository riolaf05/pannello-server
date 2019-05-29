#!/bin/sh
#bash file_conversion.sh "$(ls -1t | head -1)" <- undockerized version
bash /scripts/bash file_conversion.sh "$(ls -1t | head -1)"