package entities

import (
	"errors"
	"time"
)

// MovimentSec representa a tabela `moviment_sec` do Access
// Usado para movimentação de documentos entre seções (Sercod)
type MovimentSec struct {
	CodMov     int
	NrProtoc   int
	CodMovGeral *int // FK opcional para moviment geral
	DtMovim    time.Time
	OrigNome   string
	DestNome   string
	Obs        string
	Solucao    string
	Prazo      *time.Time
	Cumprido   string
	UsuaMov    string
}

func (m *MovimentSec) Validate() error {
	if m.CodMov == 0 {
		return errors.New("cod_mov é obrigatório")
	}
	if m.NrProtoc == 0 {
		return errors.New("nr_protoc é obrigatório")
	}
	return nil
}
