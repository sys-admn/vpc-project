.PHONY: test test-vpc test-sg test-instance test-terraform clean

# Default target
all: test

# Install dependencies
deps:
	go mod download

# Run all tests
test: deps
	go test -v -timeout 30m ./...

# Run VPC module tests
test-vpc: deps
	go test -v -timeout 30m -run TestVpcModule

# Run security group module tests
test-sg: deps
	go test -v -timeout 30m -run TestSecurityGroupModule

# Run instance module tests
test-instance: deps
	go test -v -timeout 30m -run TestInstanceModule

# Run Terraform validation tests
test-terraform: deps
	go test -v -timeout 30m -run TestTerraform

# Clean up test artifacts
clean:
	go clean -testcache