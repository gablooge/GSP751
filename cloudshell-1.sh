# #!/bin/bash

git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v3.3.0 -b v3.3.0

PROJECT_ID=$(gcloud config get-value project)

cd ~/terraform-google-network/examples/simple_project

cat > variables.tf <<EOF
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "$PROJECT_ID"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "example-vpc"
}
EOF

terraform init
terraform apply -auto-approve

terraform destroy


cd ~
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html

gsutil mb gs://$PROJECT_ID
gsutil cp *.html gs://$PROJECT_ID

