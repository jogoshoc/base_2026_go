package cadastro

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
				DtEntr:  time.Now(),
				Descr:   "Teste de documento",
				Emissor: "Teste",
				Nome:    "Teste",
				Assunto: "Teste",
				TipoDoc: "OF",
				Nat:     "Entrada",
				Destino: "ARQUIVO",
			},
			wantErr: false,
		},
		{
			name: "missing descricao",
			req: &CreateRequest{
				DtEntr:  time.Now(),
				Descr:   "",
				Emissor: "Teste",
				Nome:    "Teste",
				Assunto: "Teste",
				TipoDoc: "OF",
				Nat:     "Entrada",
				Destino: "ARQUIVO",
			},
			wantErr: true,
		},
		{
			name: "missing nome",
			req: &CreateRequest{
				DtEntr:  time.Now(),
				Descr:   "Teste",
				Emissor: "Teste",
				Nome:    "",
				Assunto: "Teste",
				TipoDoc: "OF",
				Nat:     "Entrada",
				Destino: "ARQUIVO",
			},
			wantErr: true,
		},
		{
			name: "missing destino",
			req: &CreateRequest{
				DtEntr:  time.Now(),
				Descr:   "Teste",
				Emissor: "Teste",
				Nome:    "Teste",
				Assunto: "Teste",
				TipoDoc: "OF",
				Nat:     "Entrada",
				Destino: "",
			},
			wantErr: true,
		},
		{
			name: "missing tipodoc",
			req: &CreateRequest{
				DtEntr:  time.Now(),
				Descr:   "Teste",
				Emissor: "Teste",
				Nome:    "Teste",
				Assunto: "Teste",
				TipoDoc: "",
				Nat:     "Entrada",
				Destino: "ARQUIVO",
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

func TestUpdateRequest_Fields(t *testing.T) {
	req := &UpdateRequest{
		Descr:   "Descricao atualizada",
		Nome:    "Nome atualizado",
		Assunto: "Assunto atualizado",
		Destino: "Destino atualizado",
		Obs:     "Observacao atualizada",
	}

	if req.Descr != "Descricao atualizada" {
		t.Errorf("UpdateRequest.Descr should be updated")
	}
}

func TestSearchParams_ToMap(t *testing.T) {
	params := SearchParams{
		NrProtoc: "sadm-",
		Nome:     "Teste",
		Assunto:  "Documento",
	}

	m := params.ToMap()
	if len(m) != 3 {
		t.Errorf("Expected 3 params, got %d", len(m))
	}

	if m["nrprotoc"] != "sadm-" {
		t.Errorf("Expected nrprotoc=sadm-, got %v", m["nrprotoc"])
	}
}

func TestSearchParams_ToMap_Empty(t *testing.T) {
	params := SearchParams{}
	m := params.ToMap()
	if len(m) != 0 {
		t.Errorf("Expected empty map, got %d entries", len(m))
	}
}

func TestBuildSearchQuery(t *testing.T) {
	params := SearchParams{
		Nome:    "Silva",
		Assunto: "Oficio",
	}

	query, args := BuildSearchQuery(params)
	if query == "" {
		t.Error("Query should not be empty")
	}
	if len(args) != 2 {
		t.Errorf("Expected 2 args, got %d", len(args))
	}
}
