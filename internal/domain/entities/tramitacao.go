package entities

import (
	"errors"
	"time"
)

type Tramitacao struct {
	CodMov   string
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

func (t *Tramitacao) Validate() error {
	if t.CodMov == "" {
		return errors.New("codmov é obrigatório")
	}
	if t.NrProtoc == "" {
		return errors.New("nrprotoc é obrigatório")
	}
	if t.DtMovim.IsZero() {
		return errors.New("dtmovim é obrigatório")
	}
	if t.DestNome == "" {
		return errors.New("destnome é obrigatório")
	}
	return nil
}

type Moviment struct {
	CodMov   string
	NrProtoc string
	DtMovim  time.Time
	OrigNome string
	DestNome string
	Obs      string
	Prazo    string
	UsuaMov  string
	Cumprido string
}

func (m *Moviment) Validate() error {
	if m.CodMov == "" {
		return errors.New("codmov é obrigatório")
	}
	if m.NrProtoc == "" {
		return errors.New("nrprotoc é obrigatório")
	}
	if m.DtMovim.IsZero() {
		return errors.New("dtmovim é obrigatório")
	}
	return nil
}