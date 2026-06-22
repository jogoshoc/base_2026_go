package entities

import "time"

// AudMoviment representa a tabela `aud_moviment` (unificada)
// Original SAdm: _AudMoviment, Sercod: AudMoviment
// Auditoria de alterações na movimentação de documentos
type AudMoviment struct {
	ID                  int
	CodMov              string
	NrProtoc            string
	DataAlteracao       time.Time
	DataAnt             string
	DataMod             string
	OrigAnt             string
	OrigMod             string
	DestAnt             string
	DestMod             string
	ObsAnt              string
	ObsMod              string
	PrazoAnt            string
	PrazoMod            string
	CreatedByASPRunnerPro int
}
