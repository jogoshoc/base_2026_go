package entities

import (
	"errors"
	"time"
)

type Privilegio string

const (
	PrivilegioAdmin Privilegio = "adm"
	PrivilegioUser  Privilegio = "user"
	PrivilegioVis  Privilegio = "vis"
)

func (p Privilegio) IsValid() bool {
	switch p {
	case PrivilegioAdmin, PrivilegioUser, PrivilegioVis:
		return true
	}
	return false
}

type Usuario struct {
	Codigo      int
	NrUsuario  string
	PG         string
	Nome       string
	Ramal      string
	Unidade    string
	Secao      string
	Fotografia []byte
	Senha      string
	Privilegio Privilegio
}

func (u *Usuario) Validate() error {
	if u.NrUsuario == "" {
		return errors.New("nr_usuario é obrigatório")
	}
	if u.Senha == "" {
		return errors.New("senha é obrigatória")
	}
	if !u.Privilegio.IsValid() {
		u.Privilegio = PrivilegioUser
	}
	return nil
}

func (u *Usuario) IsAdmin() bool {
	return u.Privilegio == PrivilegioAdmin
}

type NivelAcesso string

const (
	NivelAdmin  NivelAcesso = "admin"
	NivelUser   NivelAcesso = "user"
	NivelGuest  NivelAcesso = "guest"
)

type Session struct {
	ID        string
	UserID   string
	Nivel    NivelAcesso
	CreatedAt time.Time
	ExpiresAt time.Time
}

func (s *Session) IsExpired() bool {
	return time.Now().After(s.ExpiresAt)
}

func (s *Session) Extend(d time.Duration) {
	s.ExpiresAt = time.Now().Add(d)
}