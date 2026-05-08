package database

import "cgdoc/internal/domain/entities"

type UsuarioRepository interface {
	FindByNrUsuario(nrUsuario string) (*entities.Usuario, error)
	FindByID(codigo int) (*entities.Usuario, error)
	Create(u *entities.Usuario) error
	Update(u *entities.Usuario) error
	Delete(codigo int) error
	ListAll() ([]*entities.Usuario, error)
}

type CadastroRepository interface {
	FindByNrProtoc(nrprotoc string) (*entities.Cadastro, error)
	FindByID(controle int) (*entities.Cadastro, error)
	Create(c *entities.Cadastro) error
	Update(c *entities.Cadastro) error
	Delete(controle int) error
	Search(params map[string]interface{}) ([]*entities.Cadastro, error)
	ListByPrefix(prefix string, limit, offset int) ([]*entities.Cadastro, error)
	Count() (int, error)
}

type TramitacaoRepository interface {
	FindByNrProtoc(nrprotoc string) ([]*entities.Tramitacao, error)
	FindByID(codmov string) (*entities.Tramitacao, error)
	Create(t *entities.Tramitacao) error
	Update(t *entities.Tramitacao) error
	Delete(codmov string) error
}

type MovimentRepository interface {
	FindByNrProtoc(nrprotoc string) ([]*entities.Moviment, error)
	FindByID(codmov string) (*entities.Moviment, error)
	Create(m *entities.Moviment) error
	Update(m *entities.Moviment) error
	Delete(codmov string) error
}