package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformValidation tests that the Terraform code is valid
func TestTerraformValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
	}

	// Run `terraform init` and `terraform validate`
	output := terraform.InitAndValidate(t, terraformOptions)
	
	// Validate should return empty output if successful
	assert.Empty(t, output, "Expected empty output from terraform validate")
}

// TestTerraformFormat tests that the Terraform code is properly formatted
func TestTerraformFormat(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
	}

	// Run `terraform fmt -check` to check if the code is properly formatted
	// This will exit with a non-zero code if any files are not properly formatted
	terraform.RunTerraformCommand(t, terraformOptions, "fmt", "-check")
}

// TestTerraformPlan tests that the Terraform plan is valid
func TestTerraformPlan(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":     "us-west-2",
			"project_name":   "terratest-plan",
			"environment":    "test",
			"owner":          "terratest",
			"instance_count": 1,
		},
	})

	// Run `terraform plan` to check that the configuration is valid
	// This will fail if there are any errors in the plan
	terraform.InitAndPlan(t, terraformOptions)
}