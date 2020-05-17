# awsS3-multipart-upload-script
## Upload multipart files to AWS S3 using the AWS s3api tool.

When uploading a very large file to AWS S3 (> 100GB), you may wanna split the file and then upload its parts using the [Multipart file Upload](https://docs.aws.amazon.com/cli/latest/reference/s3api/upload-part.html) tool provided by AWS.

That way, if you lose connection for a reason, you'll be able to resume the upload with no problems. Also, using the prefix `--content-md5`, you can check the content of the uploaded file and compare it with your local file.

### Steps to use this script

1. [Create a multipart upload](https://docs.aws.amazon.com/cli/latest/reference/s3api/create-multipart-upload.html) using the AWS S3 API
	1. Example: `aws s3api create-multipart-upload --bucket my-bucket --key 'multipart-1'`
	2. Please, take notes of the `upload_id` and `key` values; you'll need them.
2. Clone this repo
3. Set permissions: `chmod +x multipart.file-upload-s3.sh`
4. Edit `multipart.file-upload-s3.sh` with your requirements - See *variables* below for more information.
	1. Change `bucket`, `profile`, `upload_id`, `path` and `key`.
5. Create the `logs` directory: `cd awsS3-multipart-upload-script && mkdir logs`

The script will start reading your `path` directory for files, will take the MD5 checksum of them and parse it to the S3 API as the `--content-md5` parameter, and then it will start uploading each file to the specified `bucket`.
The outputs will be sent to a log file.
Make sure to save that log file, you'll need the `ETag` output later on.

An example of the output of the script:

<code>
{
    "ETag": "\"e868e0f4719e394144ef36531ee6824c\""
}
</code>

*Variables:*
`bucket` = Your S3 bucket name.
`profile` = Your AWS profile (i.e. `aws configure --profile tests3`).
`upload_id` = Your upload_id, retrievable when executing `create-multipart-upload`.
`path` = The directory in your HD that contains the splitted files.
`key` = Object key for which the multipart upload has been initiated.