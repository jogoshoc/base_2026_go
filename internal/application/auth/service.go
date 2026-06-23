package auth

import (
	"crypto/rand"
	"encoding/hex"
	"errors"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/infrastructure/database"
	"cgdoc/internal/infrastructure/session"
)

var (
	ErrInvalidCredentials = errors.New("credenciais inválidas")
	ErrSessionExpired     = errors.New("sessão expirada")
	ErrNotAuthenticated  = errors.New("usuário não autenticado")
)

type AuthService struct {
	repo          database.UsuarioRepository
	sessionMgr    *session.SessionManager
	adminUserID   string
	cookieName    string
	sessionCookie bool
}

func NewAuthService(repo database.UsuarioRepository, sessionMgr *session.SessionManager, adminUserID string, cookieName string) *AuthService {
	return &AuthService{
		repo:        repo,
		sessionMgr:  sessionMgr,
		adminUserID: adminUserID,
		cookieName:  cookieName,
	}
}

func (s *AuthService) Login(username, password string) (*entities.Session, error) {
	usuario, err := s.repo.FindByNrUsuario(username)
	if err != nil {
		return nil, err
	}
	if usuario == nil {
		return nil, ErrInvalidCredentials
	}

	// Verificar senha: suporta bcrypt (novo) e plain text (legado)
	if !CheckPassword(password, usuario.Senha) {
		if usuario.Senha != password {
			return nil, ErrInvalidCredentials
		}
		// Migrar senha plain text para bcrypt na primeira autenticacao
		hashed, err := HashPassword(password)
		if err == nil {
			usuario.Senha = hashed
			s.repo.Update(usuario)
		}
	}

	// Determine access level
	nivel := entities.NivelUser
	if username == s.adminUserID {
		nivel = entities.NivelAdmin
	}

	sessionID := generateSessionID()
	session := s.sessionMgr.Create(sessionID, username, nivel)

	return session, nil
}

func (s *AuthService) Logout(sessionID string) {
	s.sessionMgr.Destroy(sessionID)
}

func (s *AuthService) ValidateSession(sessionID string) (*entities.Session, error) {
	session, ok := s.sessionMgr.Get(sessionID)
	if !ok {
		return nil, ErrSessionExpired
	}
	return session, nil
}

func (s *AuthService) ExtendSession(sessionID string) bool {
	return s.sessionMgr.Extend(sessionID)
}

func (s *AuthService) IsAdmin(session *entities.Session) bool {
	return session.Nivel == entities.NivelAdmin
}

func (s *AuthService) CheckSecurity(session *entities.Session, ownerID string, operacao string) bool {
	// Admin bypasses all checks
	if session.Nivel == entities.NivelAdmin {
		return true
	}
	// TODO: Implement owner-based permission check
	return true
}

func (s *AuthService) GetUserInfo(nrUsuario string) (*entities.Usuario, error) {
	return s.repo.FindByNrUsuario(nrUsuario)
}

func (s *AuthService) CookieName() string {
	return s.cookieName
}

func generateSessionID() string {
	bytes := make([]byte, 32)
	rand.Read(bytes)
	return hex.EncodeToString(bytes)
}

type LoginRequest struct {
	Username string
	Password string
	Remember bool
}

type LoginResponse struct {
	SessionID  string
	UserID     string
	Nivel      entities.NivelAcesso
	Remember   bool
	Expiration time.Duration
}