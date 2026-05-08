package cadastro

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/domain/valueobjects"
	"cgdoc/internal/infrastructure/database"
)

var (
	ErrNotFound         = errors.New("cadastro não encontrado")
	ErrAlreadyExists    = errors.New("nrprotoc já existe")
	ErrInvalidNrProtoc  = errors.New("nrprotoc inválido")
)

type CadastroService struct {
	repo   database.CadastroRepository
	prefix string
}

func NewCadastroService(repo database.CadastroRepository, prefix string) *CadastroService {
	return &CadastroService{
		repo:   repo,
		prefix: prefix,
	}
}

func (s *CadastroService) Create(req *CreateRequest) (*entities.Cadastro, error) {
	if err := req.Validate(); err != nil {
		return nil, err
	}

	// Generate NrProtoc with prefix
	nrprotoc := s.generateNrProtoc()

	c := &entities.Cadastro{
		NrProtoc:    nrprotoc,
		DtEntr:      req.DtEntr,
		Descr:       req.Descr,
		Emissor:     req.Emissor,
		Nome:        req.Nome,
		Assunto:     req.Assunto,
		TipoDoc:     req.TipoDoc,
		Nat:         req.Nat,
		Destino:     req.Destino,
		Obs:         req.Obs,
		Usuario:     req.Usuario,
		PastaArquiv: req.PastaArquiv,
		CPF:         req.CPF,
		MASP:        req.MASP,
	}

	if err := c.Validate(); err != nil {
		return nil, err
	}

	if err := s.repo.Create(c); err != nil {
		return nil, err
	}

	return c, nil
}

func (s *CadastroService) Update(controle int, req *UpdateRequest) (*entities.Cadastro, error) {
	existing, err := s.repo.FindByID(controle)
	if err != nil {
		return nil, err
	}
	if existing == nil {
		return nil, ErrNotFound
	}

	// Update fields
	if req.Descr != "" {
		existing.Descr = req.Descr
	}
	if req.Nome != "" {
		existing.Nome = req.Nome
	}
	if req.Assunto != "" {
		existing.Assunto = req.Assunto
	}
	if req.Destino != "" {
		existing.Destino = req.Destino
	}
	if req.Obs != "" {
		existing.Obs = req.Obs
	}

	if err := existing.Validate(); err != nil {
		return nil, err
	}

	if err := s.repo.Update(existing); err != nil {
		return nil, err
	}

	return existing, nil
}

func (s *CadastroService) Delete(controle int) error {
	existing, err := s.repo.FindByID(controle)
	if err != nil {
		return err
	}
	if existing == nil {
		return ErrNotFound
	}

	return s.repo.Delete(controle)
}

func (s *CadastroService) GetByID(controle int) (*entities.Cadastro, error) {
	return s.repo.FindByID(controle)
}

func (s *CadastroService) GetByNrProtoc(nrprotoc string) (*entities.Cadastro, error) {
	return s.repo.FindByNrProtoc(nrprotoc)
}

func (s *CadastroService) List(page, pageSize int) ([]*entities.Cadastro, int, error) {
	if page < 1 {
		page = 1
	}
	if pageSize < 1 {
		pageSize = 20
	}

	offset := (page - 1) * pageSize
	cadastros, err := s.repo.ListByPrefix(s.prefix, pageSize, offset)
	if err != nil {
		return nil, 0, err
	}

	total, err := s.repo.Count()
	if err != nil {
		return nil, 0, err
	}

	return cadastros, total, nil
}

func (s *CadastroService) Search(params SearchParams) ([]*entities.Cadastro, error) {
	return s.repo.Search(params.ToMap())
}

func (s *CadastroService) generateNrProtoc() string {
	// Get current count and generate next number
	now := time.Now()
	seq := now.Unix() % 10000000
	return fmt.Sprintf("%s%07d", s.prefix, seq)
}

type CreateRequest struct {
	DtEntr      time.Time
	Descr       string
	Emissor     string
	Nome        string
	Assunto     string
	TipoDoc     string
	Nat         string
	Destino     string
	Obs         string
	Usuario     string
	PastaArquiv string
	CPF         string
	MASP        string
}

func (r *CreateRequest) Validate() error {
	if r.Descr == "" {
		return errors.New("descrição é obrigatória")
	}
	if r.Nome == "" {
		return errors.New("nome é obrigatório")
	}
	if r.TipoDoc == "" {
		return errors.New("tipo de documento é obrigatório")
	}
	if r.Destino == "" {
		return errors.New("destino é obrigatório")
	}
	return nil
}

type UpdateRequest struct {
	Descr       string
	Nome        string
	Assunto     string
	Destino     string
	Obs         string
	PastaArquiv string
}

type SearchParams struct {
	NrProtoc string
	Nome     string
	Assunto  string
	Emissor  string
	Destino  string
	Nat      string
	TipoDoc  string
	Page     int
	PageSize int
}

func (p SearchParams) ToMap() map[string]interface{} {
	m := make(map[string]interface{})
	if p.NrProtoc != "" {
		m["nrprotoc"] = p.NrProtoc
	}
	if p.Nome != "" {
		m["nome"] = p.Nome
	}
	if p.Assunto != "" {
		m["assunto"] = p.Assunto
	}
	if p.Emissor != "" {
		m["emissor"] = p.Emissor
	}
	if p.Destino != "" {
		m["destino"] = p.Destino
	}
	if p.Nat != "" {
		m["nat"] = p.Nat
	}
	if p.TipoDoc != "" {
		m["tipodoc"] = p.TipoDoc
	}
	return m
}

func ParseNrProtoc(nrprotoc string) (*valueobjects.NrProtoc, error) {
	return valueobjects.ParseNrProtoc(nrprotoc)
}

func BuildSearchQuery(params SearchParams) (string, []interface{}) {
	var conditions []string
	var args []interface{}

	if params.NrProtoc != "" {
		conditions = append(conditions, "nrprotoc LIKE ?")
		args = append(args, "%"+params.NrProtoc+"%")
	}
	if params.Nome != "" {
		conditions = append(conditions, "nome LIKE ?")
		args = append(args, "%"+params.Nome+"%")
	}
	if params.Assunto != "" {
		conditions = append(conditions, "assunto LIKE ?")
		args = append(args, "%"+params.Assunto+"%")
	}
	if params.Emissor != "" {
		conditions = append(conditions, "emissor LIKE ?")
		args = append(args, "%"+params.Emissor+"%")
	}
	if params.Destino != "" {
		conditions = append(conditions, "destino = ?")
		args = append(args, params.Destino)
	}

	query := "SELECT controle, nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp FROM cadastro"
	if len(conditions) > 0 {
		query += " WHERE " + strings.Join(conditions, " AND ")
	}
	query += " ORDER BY nrprotoc DESC"

	if params.Page > 0 && params.PageSize > 0 {
		offset := (params.Page - 1) * params.PageSize
		query += " LIMIT " + strconv.Itoa(params.PageSize) + " OFFSET " + strconv.Itoa(offset)
	}

	return query, args
}