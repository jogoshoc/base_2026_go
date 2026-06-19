package moviment

import (
	"testing"
	"time"
)

func TestCreateRequest_Validate(t *testing.T) {
	tests := []struct {
		name    string
		req     *CreateRequest
		wantErr bool
	}{
		{
			name: "valid request",
			req: &CreateRequest{
				NrProtoc: "sadm-2012000001",
				DtMovim:  time.Now(),
				OrigNome: "ORIGEM",
				DestNome: "DESTINO",
				Cumprido: "Sim",
			},
			wantErr: false,
		},
		{
			name: "missing nrprotoc",
			req: &CreateRequest{
				NrProtoc: "",
				DtMovim:  time.Now(),
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.req.Validate()
			if (err != nil) != tt.wantErr {
				t.Errorf("CreateRequest.Validate() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestGenerateCodMov(t *testing.T) {
	code := generateCodMov()
	if len(code) < 15 {
		t.Errorf("Expected codmov length >= 15, got %d: %s", len(code), code)
	}
	if code[:2] != "MV" {
		t.Errorf("Expected codmov to start with MV, got %s", code[:2])
	}
}

func TestUpdateRequest_Fields(t *testing.T) {
	req := &UpdateRequest{
		Obs:      "Observacao atualizada",
		Cumprido: "Sim",
	}

	if req.Obs != "Observacao atualizada" {
		t.Errorf("UpdateRequest.Obs should be updated")
	}
}
