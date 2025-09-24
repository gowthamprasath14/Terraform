Terraform Remote Backend with AWS S3 + DynamoDB
===============================================

*1. Why Remote Backend?*
----------------------
By default, Terraform stores its state file (terraform.tfstate) locally.  
This works fine for small projects, but in team environments it creates problems:

- Collaboration issues: Only one person has the latest state on their machine.
- Risk of corruption: Local files can be deleted or overwritten.
- Security concerns: The state file may contain sensitive data such as passwords or keys.

A remote backend solves these problems by:
- Centralizing the state so everyone works from the same source.
- Allowing team collaboration without conflicts.
- Securing the state using access controls, encryption, and versioning.


*2. How to Configure Remote Backend in AWS*
-----------------------------------------
We use Amazon S3 to store the Terraform state file.

Step 1: Create an S3 bucket
    aws s3api create-bucket \
      --bucket my-terraform-state-bucket \
      --region us-east-1

Step 2: Enable versioning (for rollback)
    aws s3api put-bucket-versioning \
      --bucket my-terraform-state-bucket \
      --versioning-configuration Status=Enabled

Step 3: Create a DynamoDB table for state locking
    aws dynamodb create-table \
      --table-name terraform-locks \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST

Step 4: Configure the Terraform backend
    In main.tf:

    
    terraform {
      backend "s3" {
        bucket       = "unique-bucketname"
        key          = "folder_name/terraform.tfstate"
        region       = "ap-south-1"
        encrypt      = true
        dynamodb_table = "terraform-lock"
      }
    }

Initialize the backend:
    terraform init


*3. Why Store Lock in DynamoDB?*
-----------------------------
Terraform supports state locking to prevent multiple users from modifying the infrastructure at the same time.

Without locking:
- Two people running "terraform apply" simultaneously could corrupt the state.

With DynamoDB locking:
- Terraform creates a lock entry in DynamoDB before making changes.
- Other users must wait until the lock is released.
- This ensures consistency and prevents race conditions.


*4. Best Practices*
-----------------
- Restrict access to the S3 bucket and DynamoDB table with IAM policies.
- Enable server-side encryption (SSE or KMS) for the S3 bucket.
- Use Git workflows for collaboration instead of sharing state files.
- Enable S3 versioning to recover from accidental state file overwrites.

