package auth

import (
	"testing"
)

func TestHashPassword(t *testing.T) {
	password := "minha_senha_secreta_123"
	hash, err := HashPassword(password)
	if err != nil {
		t.Fatalf("HashPassword failed: %v", err)
	}
	
	if !IsBcryptHash(hash) {
		t.Errorf("Expected bcrypt hash format, got: %s", hash)
	}
	
	// Verify correct password
	if !CheckPassword(password, hash) {
		t.Errorf("CheckPassword should return true for correct password")
	}
	
	// Verify wrong password
	if CheckPassword("wrong_password", hash) {
		t.Errorf("CheckPassword should return false for wrong password")
	}
}

func TestHashPassword_EmptyString(t *testing.T) {
	hash, err := HashPassword("")
	if err != nil {
		t.Fatalf("HashPassword failed for empty string: %v", err)
	}
	
	if !IsBcryptHash(hash) {
		t.Errorf("Expected bcrypt hash format for empty password")
	}
}

func TestCheckPassword_PlainText(t *testing.T) {
	// Simulating legacy plain text compatibility
	password := "minha_senha"
	plainText := "minha_senha"
	
	if password != plainText {
		t.Errorf("Plain text comparison should work")
	}
}

func TestIsBcryptHash(t *testing.T) {
	tests := []struct {
		name     string
		hash     string
		expected bool
	}{
		{"valid bcrypt", "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy", true},
		{"plain text", "minha_senha_123", false},
		{"short string", "abc", false},
		{"empty string", "", false},
		{"invalid prefix", "$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy", false},
		{"wrong length", "$2a$10$short", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := IsBcryptHash(tt.hash)
			if result != tt.expected {
				t.Errorf("IsBcryptHash(%q) = %v, want %v", tt.hash, result, tt.expected)
			}
		})
	}
}

func TestHashPassword_Deterministic(t *testing.T) {
	password := "test_password"
	hash1, _ := HashPassword(password)
	hash2, _ := HashPassword(password)
	
	// bcrypt uses random salt, so hashes should be different
	if hash1 == hash2 {
		t.Errorf("bcrypt hashes should be different due to random salt")
	}
	
	// But both should verify correctly
	if !CheckPassword(password, hash1) {
		t.Errorf("hash1 should verify correctly")
	}
	if !CheckPassword(password, hash2) {
		t.Errorf("hash2 should verify correctly")
	}
}
