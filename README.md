# Data Ops Engineer – Candidate Technical Exercise 
## Introduction
This project is a technical exercise for the role of Data Ops Engineer. The developer was tasked with provisioning resources on a trial Snowflake account using Infrastructure-As-Code Terraform. The tasks at hand are as follows:
1. Create a trial account.
2. Use Terraform to provision a data warehouse that includes one of each of the following:
    - User
    - Role
    - Database
    - Schema
3. Document how provisioning will be incremented and versioned.
    - How will you add a new database/schema/role?
    - Are you able to implement CI/CD or explaine how you could increment on your solution to do so?
    - Can you create Dev/QA/Prod versions of the Database/Schema and automatically deployment with CI/CD?
    - How can changes made be audited/reviewed?
With these goals in mind the I studied just a bit to come up with a solution. Though I have no experience in DevOps this repository shows my best effort.
## Provisioning
The script `main.tf` is the terraform provisioning script. The resource block labeled `provider` holds account information and secrets. These secrets are not to hard coded in the file and are thus set to variables or any other secrets management system. In this case I would create an input variable file `terrafrom.tfvars` that contains these secrests in a key-value scheme. I could then pass this file into Terraform using the `-var-file` option. Example: `terraform apply -var-file="terraform.tfvars"`.

The resource block labeled `resource` defines the resources that are provisioned. These resources are the role, databases, schemas, and users. It also includes granting of privileges to resources.

## Adding New Database/Schema/Role
To add a new database, schema, or role to your existing Terraform configuration for Snowflake, you can simply extend the existing configuration by adding new resource blocks for each entity. Here are examples:

### Add a New Database
```
resource "snowflake_database" "new_database" 
{
  name = "new_database_name"
}
```

### Add a New Schema
```
resource "snowflake_schema" "new_schema" {
  name     = "new_schema_name"
  database = snowflake_database.new_database.name
}
```

### Add a New Role
```
resource "snowflake_role" "new_role" {
  name = "new_role_name"
}
```

After adding these resource blocks you run `terraform init` and then `terraform apply` to apply the changes.

## Implementing CI/CD
CI/CD (Continuous Integration and Continuous Deployment) can be implemented for Terraform scripts to automate provisioning and management of infrastructure. You would need to define the following:
1. Version Control System (Github, Gitlab, Bitbucket)
2. CI/CD Platform (Jenkins, Travis CI Github Actions)
3. CI/CD Pipeline Configurations
    - Create configuration file (.gitlab-ci.yml)
    - Define pipeline stages (build, test, deploy)
    - Specify the jobs and steps of each stage
    - Configure triggers (push to specific branch)
4. Automated Testing (`terraform validate`, `terraform plan`)
5. Terraform Backend Configuration
    - For remote state management and collaboration, configure a Terraform backend (AWS S3, Azure Blob Storage, etc). Update your Terraform configurations to use this backend for storing the state.
6. Environment Variables and Secrets
7. Terraform Initialization
    - `terraform init` to download necessary Terraform providers and configure the backend.
8. Monitoring and Notifications
9. Logging and Auditing
10. Rollback Strategy
11. Documentation

## Creating a Dev/QA/Prod Versions
You can create Dev, QA, and Prod versions of the database and schema using Terraform and automate the deployment with CI/CD. First, you would extend your Terraform configuration to define the resources for Dev, QA, and Prod environments separately. You can use variables to parameterize the environment-specific settings. Here's an example:
```
variable "environment" {
  description = "Environment (dev, qa, prod)"
  default     = "dev"
}

resource "snowflake_database" "example_database" {
  name = "${var.environment}_database"
}

resource "snowflake_schema" "example_schema" {
  name     = "${var.environment}_schema"
  database = snowflake_database.example_database.name
}
```

Next you would define environment-specific variables in your Terraform configuration, such as connection settings, roles, and permissions.
```
variable "dev_connection_settings" {
  type        = map
  description = "Dev environment Snowflake connection settings"
  default = {
    username = "dev_user"
    password = "dev_password"
    # Add other connection settings as needed
  }
}

variable "qa_connection_settings" {
  type        = map
  description = "QA environment Snowflake connection settings"
  default = {
    username = "qa_user"
    password = "qa_password"
    # Add other connection settings as needed
  }
}

variable "prod_connection_settings" {
  type        = map
  description = "Prod environment Snowflake connection settings"
  default = {
    username = "prod_user"
    password = "prod_password"
    # Add other connection settings as needed
  }
}
```
Next you would set up CI/CD to automate deployment. You would also configure how secrets are managed to account for the different environments. And you would create Terraform Workspaces to manage the seperate environments.
```
terraform workspace new dev
terraform workspace new qa
terraform workspace new prod
```
## Auditing and Reviewing
This can be accomplished with version control, code reviews, and logging.