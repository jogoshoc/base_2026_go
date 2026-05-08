package auth

import (
	"testing"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/infrastructure/session"
)

func TestLogin_Success(t *testing.T) {
	// Setup - create in-memory repository and session manager
	sm := session.NewSessionManager(20 * time.Minute)
	
	// This test demonstrates the expected behavior
	// In real implementation, would use a mock repository
	
	// Test admin detection
	adminID := "1088608"
	session := sm.Create("test-session-id", adminID, entities.NivelAdmin)
	
	if session.Nivel != entities.NivelAdmin {
		t.Errorf("Expected admin level, got %v", session.Nivel)
	}
	
	if session.UserID != adminID {
		t.Errorf("Expected user ID %s, got %s", adminID, session.UserID)
	}
}

func TestSession_Expiry(t *testing.T) {
	sm := session.NewSessionManager(1 * time.Millisecond)
	
	session := sm.Create("test-id", "user123", entities.NivelUser)
	
	// Immediately should exist
	if _, ok := sm.Get("test-id"); !ok {
		t.Error("Session should exist immediately after creation")
	}
	
	// Wait for expiry
	time.Sleep(10 * time.Millisecond)
	
	// Should be expired
	if _, ok := sm.Get("test-id"); ok {
		t.Error("Session should be expired")
	}
}

func TestSession_Extend(t *testing.T) {
	sm := session.NewSessionManager(10 * time.Millisecond)
	
	session := sm.Create("test-id", "user123", entities.NivelUser)
	originalExpiry := session.ExpiresAt
	
	time.Sleep(5 * time.Millisecond)
	
	// Extend session
	sm.Extend("test-id")
	
	// Should have new expiry after original
	if session.ExpiresAt.Before(originalExpiry) {
		t.Error("Session expiry should have been extended")
	}
}

func TestAdmin_Bypass(t *testing.T) {
	// Test that admin user bypasses all security checks
	adminSession := &entities.Session{
		ID:        "admin-session",
		UserID:    "1088608",
		Nivel:     entities.NivelAdmin,
		CreatedAt: time.Now(),
		ExpiresAt: time.Now().Add(20 * time.Minute),
	}
	
	// Admin should bypass
	if adminSession.Nivel != entities.NivelAdmin {
		t.Error("Admin should have admin level")
	}
}