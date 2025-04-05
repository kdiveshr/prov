REGION=$1
TAG=$2
ROLE=$3



KST=(`aws sts assume-role --role-arn $ROLE --role-session-name "deployment-$TAG" --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text`)
unset AWS_SECURITY_TOKEN
export AWS_DEFAULT_REGION=$REGION
export AWS_ACCESS_KEY_ID=${KST[0]}
export AWS_SECRET_ACCESS_KEY=${KST[1]}
export AWS_SESSION_TOKEN=${KST[2]}
export AWS_SECURITY_TOKEN=${KST[2]}

echo "#!/bin/bash"
echo "export AWS_DEFAULT_REGION='${REGION}'"
echo "export AWS_ACCESS_KEY_ID='${KST[0]}'"
echo "export AWS_ACCESS_KEY='${KST[0]}'"
echo "export AWS_SECRET_ACCESS_KEY='${KST[1]}'"
echo "export AWS_SECRET_KEY='${KST[1]}'"
echo "export AWS_SESSION_TOKEN='${KST[2]}'"      # older var seems to work the same way
echo "export AWS_SECURITY_TOKEN='${KST[2]}'"
echo "export AWS_DELEGATION_TOKEN='${KST[2]}'"