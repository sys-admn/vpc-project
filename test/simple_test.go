package test

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

// TestSimple is a simple test that always passes
func TestSimple(t *testing.T) {
	assert.True(t, true, "True should be true")
}
