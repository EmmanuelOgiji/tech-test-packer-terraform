# Emmanuel Pius-Ogiji's Sky Technical Test

## Task 1:
Create public linux image running web server with simple web  page to hit 

### Solution: (Packer installation needed)
- Populate the var.json file with aws_access_key and aws_secret_key values
Run the following commands:
- cd build-image
- packer build -var-file=vars.json image_build.json
    
## Task 2: 
Terraform - publish to a github, we should be able to pull down and run on our AWS account with minimal input ;
code to build out 3 nodes using this packer image (t2.micro)
These nodes will sit behind an ELB and be accessible publicly so we can hit the above web  page
Set up auto scaling - configure auto scaling group, auto scaling policy, launch configuration
Set up cloud watch alarm that will scale up nodes once load is beyond 60% CPU, scale back down below 40% CPU (min/max numbers up to you

### Solution:
- Populate terraform.tfvars with the access_key and secret_key values
- From the root of directory of the repo, Run:
    - terraform apply -auto-approve -var-file="terraform.tfvars"
    
Note terraform apply runs terraform plan inherently any way

Note variables are used for the following in order to provide flexibility/reusability (with desired values set as default)
The variable descriptions provide adequate information
- region
- upper_cpu_threshold
- lower_cpu_threshold
- desired_capacity
- max_size
- min_size
- alarm_evaluation_periods

At the end of the "apply", the dns to access the webpage is output on the terminal

Notes:
- Multiple subnets in different availability zones created to make deployment Multi-AZ (more available) in line with
good practice.

## Task 3:
Provide way to place load on nodes to trigger alarm

### Solution:
The solution to this problem (mostly confined to stress-test.tf) is as follows:
- A Cloudwatch/Eventbridge scheduled event runs every 10 mins
- This event triggers a SSM Run command to run an SSM document
- This document runs a command using the linux tool "stress" (installed as part of building the ami and initialized as part of the user data).
This command "stresses" the nodes for 5 mins to raise the CPU Utilization to trigger the high cpu alarm and as such the scale out action (launching new instances)
- The "GroupInServiceInstances" metric of the Autoscaling group is enabled and used to create a dashboard to show the
number of instances over time.


The reasons for this solution (over alternatives like SSH) are as follows:
- Automation: It was deemed important to make usage of the solution easier to use
- Security: Avoiding SSH in "production" is usually advised as issues with key pairs are avoided


# POSSIBLE IMPROVEMENTS:
The following are improvements that could be made but were not based on time/cost:
- Image building:
   - Consolidate to one json file that can be used for both containers and local packer versions
- Improve logging and monitoring:
   - Add access logs for ELB
   - Add flow logs for vpc
   - Look at using the cloudwatch agent to stream logs from instances for debugging
   - Set up logging for SSM Run Command in S3 or Cloudwatch
   - Use SNS topic for notifications (preferably by email) on Autoscaling events captured using Cloudwatch event rules
- Improve efficiency:
  - Look at triggering SSM Run command by events/metrics e.g number of instances rather than schedule. A Cloudwatch alarm
was considered but the lack of direct targetting to SSM means SNS+Lambda integration is needed to implement it thus decided
against
