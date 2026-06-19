package main

import (
	"database/sql"
	"log"
	"net/http"

	"cgdoc/internal/application/auth"
	"cgdoc/internal/application/cadastro"
	"cgdoc/internal/application/tramitacao"
	"cgdoc/internal/application/moviment"
	"cgdoc/internal/config"
	_ "github.com/go-sql-driver/mysql"
	"cgdoc/internal/domain/valueobjects"
	"cgdoc/internal/infrastructure/database"
	"cgdoc/internal/infrastructure/session"
	"cgdoc/internal/interfaces/http/sercod"
	"cgdoc/internal/interfaces/middleware"

	"github.com/go-chi/chi"
	chimw "github.com/go-chi/chi/middleware"
)

func main() {
	cfg := config.Load()

	// Override port for Sercod
	cfg.Server.Port = "8082"

	// Database connection
	db, err := sql.Open("mysql", cfg.Database.DSN())
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatal("Failed to ping database:", err)
	}

	// Initialize repositories
	mariaDB := database.NewMariaDB(db)
	usuarioRepo := mariaDB.Usuario()

	// Session manager
	sessionMgr := session.NewSessionManager(cfg.Session.Timeout)

	// Auth service
	authService := auth.NewAuthService(usuarioRepo, sessionMgr, cfg.Admin.UserID, cfg.Session.CookieName)

	// Cadastro service - Sercod uses sercod- prefix
	cadastroRepo := mariaDB.Cadastro()
	cadastroService := cadastro.NewCadastroService(cadastroRepo, valueobjects.PrefixSercod)

	// Tramitação service
	tramitacaoRepo := mariaDB.Tramitacao()
	tramitacaoService := tramitacao.NewTramitacaoService(tramitacaoRepo)

	// Moviment service
	movimentRepo := mariaDB.Moviment()
	movimentService := moviment.NewMovimentService(movimentRepo)

	// Handlers
	authHandler := sercod.NewAuthHandler(authService, cfg.Session.CookieName, cfg.Session.Timeout)
	cadastroHandler := sercod.NewCadastroHandler(cadastroService)
	tramitacaoHandler := sercod.NewTramitacaoHandler(tramitacaoService, cadastroService)
	movimentHandler := sercod.NewMovimentHandler(movimentService, cadastroService)

	// Router
	r := chi.NewRouter()
	r.Use(chimw.Logger)
	r.Use(chimw.Recoverer)

	// Public routes
	r.Get("/login", authHandler.Login)
	r.Post("/login", authHandler.Login)
	r.Get("/logout", authHandler.Logout)

	// Protected routes
	authMiddleware := middleware.NewAuthMiddleware(authService, cfg.Session.CookieName)
	protected := chi.NewRouter()
	protected.Use(authMiddleware.RequireAuth)
	protected.Get("/menu", authHandler.Menu)

	// Cadastro routes
	protected.Get("/cadastro/list", cadastroHandler.List)
	protected.Get("/cadastro/add", cadastroHandler.Add)
	protected.Post("/cadastro/add", cadastroHandler.Add)
	protected.Get("/cadastro/edit", cadastroHandler.Edit)
	protected.Post("/cadastro/edit", cadastroHandler.Edit)
	protected.Get("/cadastro/search", cadastroHandler.Search)
	protected.Post("/cadastro/search", cadastroHandler.Search)
	protected.Get("/cadastro/view", cadastroHandler.View)
	protected.Get("/cadastro/delete", cadastroHandler.Delete)

	// Tramitação routes
	protected.Get("/tramitacao/list", tramitacaoHandler.List)
	protected.Get("/tramitacao/add", tramitacaoHandler.Add)
	protected.Post("/tramitacao/add", tramitacaoHandler.Add)

	// Moviment routes
	protected.Get("/moviment/list", movimentHandler.List)
	protected.Get("/moviment/add", movimentHandler.Add)
	protected.Post("/moviment/add", movimentHandler.Add)

	r.Mount("/", protected)

	// Start server
	addr := cfg.Server.Host + ":" + cfg.Server.Port
	log.Printf("Starting Sercod server on %s", addr)
	log.Fatal(http.ListenAndServe(addr, r))
}