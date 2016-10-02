#!/bin/bash

# Find last backup file
echo "Command: aws s3 ls s3://$S3_BUCKET_NAME"
aws s3 ls s3://$S3_BUCKET_NAME
echo "Command: aws s3 ls s3://$S3_BUCKET_NAME | awk -F \" \" '{print $4}'"
aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}'
echo "Command: aws s3 ls s3://$S3_BUCKET_NAME | awk -F \" \" '{print $4}' | grep ^$BACKUP_NAME"
aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME
echo "Command: aws s3 ls s3://$S3_BUCKET_NAME | awk -F \" \" '{print $4}' | grep ^$BACKUP_NAME | sort -r"
aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r
echo "Command: aws s3 ls s3://$S3_BUCKET_NAME | awk -F \" \" '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1"
aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1

: ${LAST_BACKUP:=$(aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}
echo "We think the last backup is:"
echo $LAST_BACKUP

# Download backup from S3
echo "Command: aws s3 cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP"
aws s3 cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP

# Extract backup
echo "Command: tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION"
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION
