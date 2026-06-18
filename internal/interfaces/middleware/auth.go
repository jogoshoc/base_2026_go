package middleware

import (
	"context"
	"net/http"

	"cgdoc/internal/domain/entities"
)

type contextKey string

const SessionContextKey contextKey = "session"

type AuthMiddleware struct {
	authService interface {
		ValidateSession(string) (*entities.Session, error)
		ExtendSession(string) bool
	}
	cookieName string
}

func NewAuthMiddleware(authService interface {
	ValidateSession(string) (*entities.Session, error)
	ExtendSession(string) bool
}, cookieName string) *AuthMiddleware {
	return &AuthMiddleware{
		authService: authService,
		cookieName:  cookieName,
	}
}

func (m *AuthMiddleware) RequireAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		cookie, err := r.Cookie(m.cookieName)
		if err != nil {
			http.Redirect(w, r, "/login?message=expired", http.StatusFound)
			return
		}

		session, err := m.authService.ValidateSession(cookie.Value)
		if err != nil {
			http.Redirect(w, r, "/login?message=expired", http.StatusFound)
			return
		}

		m.authService.ExtendSession(cookie.Value)

		ctx := WithSession(r.Context(), session)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func WithSession(ctx context.Context, session *entities.Session) context.Context {
	return context.WithValue(ctx, SessionContextKey, session)
}

func GetSessionFromContext(ctx context.Context) (*entities.Session, bool) {
	session, ok := ctx.Value(SessionContextKey).(*entities.Session)
	return session, ok
}
