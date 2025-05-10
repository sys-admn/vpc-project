# Terratest for AWS VPC and EC2 Infrastructure

This directory contains Terratest tests for validating the Terraform modules in this project.

## Prerequisites

- Go 1.21 or later
- AWS credentials configured
- Terraform installed

## Test Structure

The tests are organized into several files:

- `vpc_test.go`: Tests the VPC module functionality
- `security_group_test.go`: Tests the security group module functionality
- `instance_test.go`: Tests the EC2 instance module functionality
- `terraform_test.go`: Tests Terraform code quality and validation

## Running Tests

To run all tests:

```bash
cd test
go test -v -timeout 30m
```

To run a specific test:

```bash
cd test
go test -v -timeout 30m -run TestVpcModule
```

## Test Parameters

The tests use the following parameters:

- AWS Region: us-west-2
- Environment: test
- Instance Type: t2.micro
- Root Volume Size: 10GB
- Root Volume Type: gp3

## Important Notes

1. These tests create real AWS resources and may incur charges to your AWS account.
2. The tests use `terraform destroy` to clean up resources after testing, but if a test fails, you may need to manually clean up resources.
3. Each test runs in parallel to speed up execution, but this means they create separate resources.

## Adding New Tests

To add a new test:

1. Create a new Go file in this directory
2. Import the necessary Terratest modules
3. Create a test function that starts with `Test`
4. Use the Terratest functions to validate your infrastructure

Example:

```go
func TestNewFeature(t *testing.T) {
    t.Parallel()
    
    // Test setup and validation
}
```