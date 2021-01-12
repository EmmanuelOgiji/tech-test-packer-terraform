# tech-test-packer-terraform

Task 1:
Create public linux image running web server with simple web  page to hit 

Solution:
- Populate the var.json file with aws_access_key and aws_secret_key values
Run the following commands:
- cd build-image
- packer build -var-file=vars.json image_build.json

Alternate Solution: Container (No packer installation needed):
Run
- docker run -it \
    --mount type=bind,source=$PWD/build-image,target=/mnt/build-image \
    hashicorp/packer:latest build \
    --var-file /mnt/build-image/vars.json \
    /mnt/build-image/container_image_build.json
    
Task 2: 
Terraform - publish to a github, we should be able to pull down and run on our AWS account with minimal input ;
code to build out 3 nodes using this packer image (t2.micro)
These nodes will sit behind an ELB and be accessible publicly so we can hit the above web  page
Set up auto scaling - configure auto scaling group, auto scaling policy, launch configuration
Set up cloud watch alarm that will scale up nodes once load is beyond 60% CPU, scale back down below 40% CPU (min/max numbers up to you
Provide way to place load on nodes to trigger alarm
If any fixed / account specific values are needed to run Terraform that cannot be collected with data lookups, these should be prompted for when running terraform plan / apply by the end user
README in the github repo should detail any input required from the user to get things running

Solution:
- Populate terraform.tfvars with the access_key and secret_key values
- From the root of directory of the repo, Run:
    - terraform apply -var-file="terraform.tfvars" and enter yes when prompted
    
Note terraform apply runs terraform plan inherently any way
