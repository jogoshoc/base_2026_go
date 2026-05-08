package sadm

import (
	"net/http"
	"time"

	"cgdoc/internal/application/auth"
	"cgdoc/internal/domain/entities"
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
		// Render login template
		w.Write([]byte(`<!DOCTYPE html>
<html>
<head><title>Login - SAdm</title></head>
<body>
<h1>Login SAdm</h1>
<form method="post">
  <input type="text" name="username" placeholder="Usuário" required>
  <input type="password" name="password" placeholder="Senha" required>
  <label><input type="checkbox" name="remember"> Lembrar senha</label>
  <button type="submit" name="btnSubmit" value="Login">Entrar</button>
</form>
</body>
</html>`))
		return
	}

	// Handle POST
	r.ParseForm()
	username := r.Form.Get("username")
	password := r.Form.Get("password")
	remember := r.Form.Get("remember") == "on"

	session, err := h.authService.Login(username, password)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte("Credenciais inválidas"))
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

	w.Write([]byte(`<!DOCTYPE html>
<html>
<head><title>Menu - SAdm</title></head>
<body>
<h1>Menu SAdm</h1>
<p>Usuário: ` + session.UserID + `</p>
<p>Nível: ` + string(session.Nivel) + `</p>
<ul>
<li><a href="/cadastro/list">Cadastros</a></li>
<li><a href="/tramitacao/list">Tramitações</a></li>
<li><a href="/moviment/list">Movimentações</a></li>
<li><a href="/login?a=logout">Sair</a></li>
</ul>
</body>
</html>`))
}