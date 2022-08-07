#!/bin/bash
#
#

set -x

bucket=multipart-file-upload-bucket-test
profile='test-aws-profile'
upload_id='1B________Tw--' # Hidden for security reasons.
key='large_test_file'

part_number=0

for f in /home/lucas/aws-upload-test/files/x/*
do
        ((part_number=part_number+1))
        md5=$(openssl md5 -binary ${f} | base64)
        aws s3api upload-part --bucket ${bucket} --key $key --profile $profile --part-number $part_number --body ${f} --upload-id ${upload_id} --content-md5 ${md5} | tee -a logs/upload-part.$part_number-s3.log
        cat logs/upload-part.$part_number-s3.log | awk -F'"' '{print $5}' | cut -f 1 -d '\' | awk NF | awk '{ print "{\"ETag\":\"" $1 "\",\"PartNumber\": '$part_number' }," }' >> logs/output-test.json 
done
