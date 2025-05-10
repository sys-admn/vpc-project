package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestInstanceModule tests the EC2 instance module
func TestInstanceModule(t *testing.T) {
	t.Parallel()

	// Generate a random pet name to prevent a naming conflict
	uniqueID := random.UniqueId()
	awsRegion := "us-west-2"
	instanceType := "t2.micro"
	instanceCount := 2
	rootVolumeSize := 10
	rootVolumeType := "gp3"

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":     awsRegion,
			"project_name":   fmt.Sprintf("terratest-%s", uniqueID),
			"environment":    "test",
			"owner":          "terratest",
			"instance_count": instanceCount,
			"instance_type":  instanceType,
			"root_volume_size": rootVolumeSize,
			"root_volume_type": rootVolumeType,
			"enable_detailed_monitoring": true,
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
	instanceIDs := terraform.OutputList(t, terraformOptions, "instance_ids")
	publicIPs := terraform.OutputList(t, terraformOptions, "public_ips")
	elasticIPs := terraform.OutputList(t, terraformOptions, "elastic_ips")

	// Verify that the correct number of instances were created
	assert.Equal(t, instanceCount, len(instanceIDs), fmt.Sprintf("Expected %d EC2 instances", instanceCount))
	assert.Equal(t, instanceCount, len(publicIPs), fmt.Sprintf("Expected %d public IPs", instanceCount))
	assert.Equal(t, instanceCount, len(elasticIPs), fmt.Sprintf("Expected %d elastic IPs", instanceCount))

	// Verify instance properties
	for _, instanceID := range instanceIDs {
		instance := aws.GetEc2InstanceById(t, instanceID, awsRegion)
		
		// Check instance type
		assert.Equal(t, instanceType, instance.InstanceType, "Instance type should match")
		
		// Check instance state
		assert.Equal(t, "running", instance.State, "Instance should be in running state")
		
		// Check detailed monitoring
		assert.True(t, instance.Monitoring == "enabled", "Detailed monitoring should be enabled")
		
		// Check root volume
		rootVolume := instance.RootBlockDevice
		assert.Equal(t, rootVolumeSize, rootVolume.VolumeSize, "Root volume size should match")
		assert.Equal(t, rootVolumeType, rootVolume.VolumeType, "Root volume type should match")
		assert.True(t, rootVolume.Encrypted, "Root volume should be encrypted")
		
		// Check tags
		assert.Equal(t, fmt.Sprintf("terratest-%s", uniqueID), instance.Tags["Project"], "Project tag should match")
		assert.Equal(t, "test", instance.Tags["Environment"], "Environment tag should match")
		assert.Equal(t, "terratest", instance.Tags["Owner"], "Owner tag should match")
		assert.Equal(t, "true", instance.Tags["Terraform"], "Terraform tag should be true")
	}
}