# terraform
terraform scripts for learning purpose. 

----------------basic setup------------------------------
download terrform from the official website. 
for aws provisioning, install aws cli 
after installing aws cli, run aws configure to create your default profile. 
check aws configuration by running the below command "aws s3 ls" or "aws eks list-clusters" to verify your account connectivity. 

----------------------------------------------------------




In directory <b>msk cluster creation.</b>
terrform script to create a MSK kafka cluster in AWS. 
vars are declared in 2 different environments prod and non-prod. 

change the inputs in tfvars/prod.tfvars and other environment tfvars/non-prod.tfvars. 
do not change any thing other than that. 

then execute the command for planing and see the output. 

terraform plan -var-file=".\tfvars\non-prod.tfvars"

and execute the below command to apply the changes 

terraform apply -var-file=".\tfvars\non-prod.tfvars"
