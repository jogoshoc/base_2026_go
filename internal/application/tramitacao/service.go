package tramitacao

import (
	"errors"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/infrastructure/database"
)

var (
	ErrNotFound       = errors.New("tramitação não encontrada")
	ErrDestinoRequired = errors.New("destino é obrigatório")
)

type TramitacaoService struct {
	repo database.TramitacaoRepository
}

func NewTramitacaoService(repo database.TramitacaoRepository) *TramitacaoService {
	return &TramitacaoService{repo: repo}
}

func (s *TramitacaoService) Create(req *CreateRequest) (*entities.Tramitacao, error) {
	if err := req.Validate(); err != nil {
		return nil, err
	}

	t := &entities.Tramitacao{
		CodMov:   generateCodMov(),
		NrProtoc: req.NrProtoc,
		DtMovim:  req.DtMovim,
		OrigNome: req.OrigNome,
		DestNome: req.DestNome,
		Obs:      req.Obs,
		Prazo:    req.Prazo,
		Emissor:  req.Emissor,
		Assunto:  req.Assunto,
		TipoDoc:  req.TipoDoc,
		Descr:    req.Descr,
		Nome:     req.Nome,
		DtEntr:   req.DtEntr,
	}

	if err := t.Validate(); err != nil {
		return nil, err
	}

	if err := s.repo.Create(t); err != nil {
		return nil, err
	}

	return t, nil
}

func (s *TramitacaoService) GetByNrProtoc(nrprotoc string) ([]*entities.Tramitacao, error) {
	return s.repo.FindByNrProtoc(nrprotoc)
}

func (s *TramitacaoService) GetByID(codmov string) (*entities.Tramitacao, error) {
	return s.repo.FindByID(codmov)
}

func (s *TramitacaoService) Update(codmov string, req *UpdateRequest) (*entities.Tramitacao, error) {
	existing, err := s.repo.FindByID(codmov)
	if err != nil {
		return nil, err
	}
	if existing == nil {
		return nil, ErrNotFound
	}

	if req.DestNome != "" {
		existing.DestNome = req.DestNome
	}
	if req.Obs != "" {
		existing.Obs = req.Obs
	}
	if req.Prazo != "" {
		existing.Prazo = req.Prazo
	}

	if err := existing.Validate(); err != nil {
		return nil, err
	}

	if err := s.repo.Update(existing); err != nil {
		return nil, err
	}

	return existing, nil
}

func (s *TramitacaoService) Delete(codmov string) error {
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
	return "TM" + time.Now().Format("20060102150405")
}

type CreateRequest struct {
	NrProtoc string
	DtMovim  time.Time
	OrigNome string
	DestNome string
	Obs      string
	Prazo    string
	Emissor  string
	Assunto  string
	TipoDoc  string
	Descr    string
	Nome     string
	DtEntr   time.Time
}

func (r *CreateRequest) Validate() error {
	if r.NrProtoc == "" {
		return errors.New("nrprotoc é obrigatório")
	}
	if r.DestNome == "" {
		return ErrDestinoRequired
	}
	if r.DtMovim.IsZero() {
		r.DtMovim = time.Now()
	}
	return nil
}

type UpdateRequest struct {
	DestNome string
	Obs      string
	Prazo    string
}