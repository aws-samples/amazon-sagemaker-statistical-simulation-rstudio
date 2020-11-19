# The name and tag of our algorithm
image_name=$1
tag=$2

#set -e # stop if anything fails

# Build the docker image locally with the image name and then push it to ECR
# with the full name.
docker build -t ${image_name} .

# Get the AWS account ID
account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
region=${region:-us-west-2}

# Define the full image name on Amazon ECR
fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image_name}:${tag}"

# If the repository doesn't exist in ECR, create it.
aws ecr describe-repositories --repository-names "${image_name}" > /dev/null 2>&1

if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${image_name}" > /dev/null
fi

# Get the login command from ECR and execute it directly
$(aws ecr get-login --region ${region} --no-include-email)

# Tag and push the local image to Amazon ECR
docker tag ${image_name} ${fullname}
docker push ${fullname}
