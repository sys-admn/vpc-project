package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestSecurityGroupModule tests the security group module
func TestSecurityGroupModule(t *testing.T) {
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
			"security_group_ingress_rules": []map[string]interface{}{
				{
					"from_port":   22,
					"to_port":     22,
					"protocol":    "tcp",
					"cidr_blocks": []string{"192.168.1.0/24"},
					"description": "Allow SSH access from test network",
				},
				{
					"from_port":   80,
					"to_port":     80,
					"protocol":    "tcp",
					"cidr_blocks": []string{"0.0.0.0/0"},
					"description": "Allow HTTP access",
				},
			},
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
	securityGroupID := terraform.Output(t, terraformOptions, "security_group_id")
	securityGroupName := terraform.Output(t, terraformOptions, "security_group_name")

	// Verify that the security group exists
	assert.NotEmpty(t, securityGroupID, "Security Group ID should not be empty")
	assert.NotEmpty(t, securityGroupName, "Security Group Name should not be empty")
}