package auth

import (
	"testing"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/infrastructure/session"
)

func TestLogin_Success(t *testing.T) {
	sm := session.NewSessionManager(20 * time.Minute)

	adminID := "1088608"
	sess := sm.Create("test-session-id", adminID, entities.NivelAdmin)

	if sess.Nivel != entities.NivelAdmin {
		t.Errorf("Expected admin level, got %v", sess.Nivel)
	}

	if sess.UserID != adminID {
		t.Errorf("Expected user ID %s, got %s", adminID, sess.UserID)
	}
}

func TestSession_Expiry(t *testing.T) {
	sm := session.NewSessionManager(1 * time.Millisecond)

	sess := sm.Create("test-id", "user123", entities.NivelUser)

	if _, ok := sm.Get("test-id"); !ok {
		t.Error("Session should exist immediately after creation")
	}

	if sess.IsExpired() {
		t.Error("Session should not be expired immediately")
	}

	time.Sleep(10 * time.Millisecond)

	if _, ok := sm.Get("test-id"); ok {
		t.Error("Session should be expired after timeout")
	}
}

func TestSession_Extend(t *testing.T) {
	sm := session.NewSessionManager(10 * time.Millisecond)

	sess := sm.Create("test-id", "user123", entities.NivelUser)
	originalExpiry := sess.ExpiresAt

	time.Sleep(5 * time.Millisecond)

	sm.Extend("test-id")

	if sess.ExpiresAt.Before(originalExpiry) {
		t.Error("Session expiry should have been extended")
	}
}

func TestAdmin_Bypass(t *testing.T) {
	adminSession := &entities.Session{
		ID:        "admin-session",
		UserID:    "1088608",
		Nivel:     entities.NivelAdmin,
		CreatedAt: time.Now(),
		ExpiresAt: time.Now().Add(20 * time.Minute),
	}

	if adminSession.Nivel != entities.NivelAdmin {
		t.Error("Admin should have admin level")
	}
}
