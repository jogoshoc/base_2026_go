package sadm

import (
	"net/http"
	"time"

	"cgdoc/internal/application/auth"
	"cgdoc/internal/interfaces/http/templates"
	"cgdoc/internal/interfaces/middleware"
)

type AuthHandler struct {
	authService  *auth.AuthService
	cookieName   string
	sessionTTL   time.Duration
}

func NewAuthHandler(authService *auth.AuthService, cookieName string, sessionTTL time.Duration) *AuthHandler {
	return &AuthHandler{
		authService: authService,
		cookieName:  cookieName,
		sessionTTL:  sessionTTL,
	}
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		data := &templates.RenderData{
			Title:           "Login",
			Subsystem:       "SAdm",
			ContentTemplate: "login-content",
		}
		templates.Render(w, "login", data)
		return
	}

	// Handle POST
	r.ParseForm()
	username := r.Form.Get("username")
	password := r.Form.Get("password")
	remember := r.Form.Get("remember") == "on"

	session, err := h.authService.Login(username, password)
	if err != nil {
		data := &templates.RenderData{
			Title:           "Login",
			Subsystem:       "SAdm",
			ErrorMsg:        "Credenciais inválidas",
			ContentTemplate: "login-content",
		}
		w.WriteHeader(http.StatusUnauthorized)
		templates.Render(w, "login", data)
		return
	}

	// Set session cookie
	cookie := &http.Cookie{
		Name:     h.cookieName,
		Value:    session.ID,
		Path:     "/",
		HttpOnly: true,
	}
	if remember {
		cookie.Expires = time.Now().Add(365 * 24 * time.Hour)
	}
	http.SetCookie(w, cookie)

	// Redirect to menu
	http.Redirect(w, r, "/menu", http.StatusFound)
}

func (h *AuthHandler) Logout(w http.ResponseWriter, r *http.Request) {
	cookie, err := r.Cookie(h.cookieName)
	if err == nil {
		h.authService.Logout(cookie.Value)
	}

	// Clear cookie
	http.SetCookie(w, &http.Cookie{
		Name:   h.cookieName,
		Value:  "",
		Path:   "/",
		MaxAge: -1,
	})

	http.Redirect(w, r, "/login", http.StatusFound)
}

func (h *AuthHandler) Menu(w http.ResponseWriter, r *http.Request) {
	session, ok := middleware.GetSessionFromContext(r.Context())
	if !ok {
		http.Redirect(w, r, "/login", http.StatusFound)
		return
	}

	// Look up user info for display name
	userInfo, err := h.authService.GetUserInfo(session.UserID)
	var nome, privilegio string
	if err == nil && userInfo != nil {
		nome = userInfo.Nome
		privilegio = string(userInfo.Privilegio)
	} else {
		nome = session.UserID
		privilegio = string(session.Nivel)
	}

	data := &templates.RenderData{
		Title:      "Menu",
		Subsystem:  "SAdm",
		ActiveMenu: "menu",
		User: &templates.UserData{
			Nome:       nome,
			NrUsuario:  session.UserID,
			Privilegio: privilegio,
		},
	}
	templates.Render(w, "menu", data)
}