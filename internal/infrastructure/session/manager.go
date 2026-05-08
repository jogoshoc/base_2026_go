package session

import (
	"sync"
	"time"

	"cgdoc/internal/domain/entities"
)

const (
	DefaultSessionTimeout = 20 * time.Minute
)

type SessionManager struct {
	sessions map[string]*entities.Session
	mu       sync.RWMutex
	timeout  time.Duration
}

func NewSessionManager(timeout time.Duration) *SessionManager {
	if timeout == 0 {
		timeout = DefaultSessionTimeout
	}
	return &SessionManager{
		sessions: make(map[string]*entities.Session),
		timeout:  timeout,
	}
}

func (sm *SessionManager) Create(sessionID, userID string, nivel entities.NivelAcesso) *entities.Session {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	now := time.Now()
	session := &entities.Session{
		ID:        sessionID,
		UserID:    userID,
		Nivel:     nivel,
		CreatedAt: now,
		ExpiresAt: now.Add(sm.timeout),
	}
	sm.sessions[sessionID] = session
	return session
}

func (sm *SessionManager) Get(sessionID string) (*entities.Session, bool) {
	sm.mu.RLock()
	defer sm.mu.RUnlock()

	session, ok := sm.sessions[sessionID]
	if !ok {
		return nil, false
	}
	if session.IsExpired() {
		return nil, false
	}
	return session, true
}

func (sm *SessionManager) Extend(sessionID string) bool {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	session, ok := sm.sessions[sessionID]
	if !ok {
		return false
	}
	session.Extend(sm.timeout)
	return true
}

func (sm *SessionManager) Destroy(sessionID string) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	delete(sm.sessions, sessionID)
}

func (sm *SessionManager) DestroyAll() {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	sm.sessions = make(map[string]*entities.Session)
}

func (sm *SessionManager) Cleanup() {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	now := time.Now()
	for id, session := range sm.sessions {
		if now.After(session.ExpiresAt) {
			delete(sm.sessions, id)
		}
	}
}