package entities

import (
	"errors"
	"time"
)

type Cadastro struct {
	Controle     int
	NrProtoc    string
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

func (c *Cadastro) Validate() error {
	if c.NrProtoc == "" {
		return errors.New("nrprotoc é obrigatório")
	}
	if c.DtEntr.IsZero() {
		return errors.New("dtentr é obrigatório")
	}
	if c.Descr == "" {
		return errors.New("descr é obrigatório")
	}
	if c.Emissor == "" {
		return errors.New("emissor é obrigatório")
	}
	if c.Nome == "" {
		return errors.New("nome é obrigatório")
	}
	if c.Assunto == "" {
		return errors.New("assunto é obrigatório")
	}
	if c.TipoDoc == "" {
		return errors.New("tipodoc é obrigatório")
	}
	if c.Nat == "" {
		return errors.New("nat é obrigatório")
	}
	if c.Destino == "" {
		return errors.New("destino é obrigatório")
	}
	return nil
}

func (c *Cadastro) HasPrefix(prefix string) bool {
	return len(c.NrProtoc) > len(prefix) && c.NrProtoc[:len(prefix)] == prefix
}