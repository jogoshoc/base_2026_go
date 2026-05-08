package moviment

import (
	"errors"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/infrastructure/database"
)

var (
	ErrNotFound = errors.New("movimentação não encontrada")
)

type MovimentService struct {
	repo database.MovimentRepository
}

func NewMovimentService(repo database.MovimentRepository) *MovimentService {
	return &MovimentService{repo: repo}
}

func (s *MovimentService) Create(req *CreateRequest) (*entities.Moviment, error) {
	if err := req.Validate(); err != nil {
		return nil, err
	}

	m := &entities.Moviment{
		CodMov:   generateCodMov(),
		NrProtoc: req.NrProtoc,
		DtMovim:  req.DtMovim,
		OrigNome: req.OrigNome,
		DestNome: req.DestNome,
		Obs:      req.Obs,
		Prazo:    req.Prazo,
		UsuaMov:  req.UsuaMov,
		Cumprido: req.Cumprido,
	}

	if err := m.Validate(); err != nil {
		return nil, err
	}

	if err := s.repo.Create(m); err != nil {
		return nil, err
	}

	return m, nil
}

func (s *MovimentService) GetByNrProtoc(nrprotoc string) ([]*entities.Moviment, error) {
	return s.repo.FindByNrProtoc(nrprotoc)
}

func (s *MovimentService) GetByID(codmov string) (*entities.Moviment, error) {
	return s.repo.FindByID(codmov)
}

func (s *MovimentService) Update(codmov string, req *UpdateRequest) (*entities.Moviment, error) {
	existing, err := s.repo.FindByID(codmov)
	if err != nil {
		return nil, err
	}
	if existing == nil {
		return nil, ErrNotFound
	}

	if req.Cumprido != "" {
		existing.Cumprido = req.Cumprido
	}
	if req.Obs != "" {
		existing.Obs = req.Obs
	}

	if err := s.repo.Update(existing); err != nil {
		return nil, err
	}

	return existing, nil
}

func (s *MovimentService) Delete(codmov string) error {
	existing, err := s.repo.FindByID(codmov)
	if err != nil {
		return err
	}
	if existing == nil {
		return ErrNotFound
	}

	return s.repo.Delete(codmov)
}

func generateCodMov() string {
	return "MV" + time.Now().Format("20060102150405")
}

type CreateRequest struct {
	NrProtoc string
	DtMovim  time.Time
	OrigNome string
	DestNome string
	Obs      string
	Prazo    string
	UsuaMov  string
	Cumprido string
}

func (r *CreateRequest) Validate() error {
	if r.NrProtoc == "" {
		return errors.New("nrprotoc é obrigatório")
	}
	if r.DtMovim.IsZero() {
		r.DtMovim = time.Now()
	}
	return nil
}

type UpdateRequest struct {
	Obs      string
	Cumprido string
}