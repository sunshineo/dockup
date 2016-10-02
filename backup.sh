#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz
echo "Going to create tarball: $tarball for path: $PATHS_TO_BACKUP with options $BACKUP_TAR_OPTION"

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# Create bucket, if it doesn't already exist
echo "Command: aws s3 ls | grep $S3_BUCKET_NAME | wc -l"
aws s3 ls | grep $S3_BUCKET_NAME | wc -l
BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
	echo "Bucket already exists."
then
  echo "Bucket does not exist. Create now."
  echo "Command: aws s3 mb s3://$S3_BUCKET_NAME"
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
echo "Command: aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball"
aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball

# Clean up
rm $tarball
