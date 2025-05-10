package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestVpcModule tests the VPC module
func TestVpcModule(t *testing.T) {
	t.Parallel()

	// Generate a random pet name to prevent a naming conflict
	uniqueID := random.UniqueId()
	awsRegion := "us-west-2"

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":   awsRegion,
			"project_name": fmt.Sprintf("terratest-%s", uniqueID),
			"environment":  "test",
			"owner":        "terratest",
			"instance_count": 1,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	subnetID := terraform.Output(t, terraformOptions, "subnet_id")
	securityGroupID := terraform.Output(t, terraformOptions, "security_group_id")
	instanceIDs := terraform.OutputList(t, terraformOptions, "instance_ids")

	// Verify that the VPC exists
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	vpc := aws.GetVpcById(t, vpcID, awsRegion)
	assert.Equal(t, "10.0.0.0/16", vpc.CidrBlock)

	// Verify that the subnet exists
	assert.NotEmpty(t, subnetID, "Subnet ID should not be empty")
	subnet := aws.GetSubnetById(t, subnetID, awsRegion)
	assert.Equal(t, "10.0.0.0/20", subnet.CidrBlock)

	// Verify that the security group exists
	assert.NotEmpty(t, securityGroupID, "Security Group ID should not be empty")

	// Verify that the EC2 instances exist
	assert.Equal(t, 1, len(instanceIDs), "Expected 1 EC2 instance")
	for _, instanceID := range instanceIDs {
		instance := aws.GetEc2InstanceById(t, instanceID, awsRegion)
		assert.Equal(t, "t2.micro", instance.InstanceType)
		assert.Equal(t, "running", instance.State)
	}
}