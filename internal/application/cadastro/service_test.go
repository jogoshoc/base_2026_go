package cadastro

import (
	"testing"
	"time"

	"cgdoc/internal/domain/entities"
	"cgdoc/internal/domain/valueobjects"
)

func TestCadastro_Validate(t *testing.T) {
	tests := []struct {
		name    string
		c       *entities.Cadastro
		wantErr bool
	}{
		{
			name: "valid cadastro",
			c: &entities.Cadastro{
				NrProtoc: "sadm-0000001",
				DtEntr:   time.Now(),
				Descr:    "Test",
				Emissor:  "Test",
				Nome:     "Test",
				Assunto:  "Test",
				TipoDoc:  "Test",
				Nat:      "Entrada",
				Destino:  "SERCOD",
			},
			wantErr: false,
		},
		{
			name: "missing nrprotoc",
			c: &entities.Cadastro{
				DtEntr:  time.Now(),
				Descr:   "Test",
				Emissor: "Test",
				Nome:    "Test",
				Assunto: "Test",
				TipoDoc: "Test",
				Nat:     "Entrada",
				Destino: "SERCOD",
			},
			wantErr: true,
		},
		{
			name: "missing required fields",
			c: &entities.Cadastro{
				NrProtoc: "sadm-0000001",
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.c.Validate()
			if (err != nil) != tt.wantErr {
				t.Errorf("Validate() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestCadastro_HasPrefix(t *testing.T) {
	c := &entities.Cadastro{NrProtoc: "sadm-0000001"}
	
	if !c.HasPrefix("sadm-") {
		t.Error("Should have sadm- prefix")
	}
	
	if c.HasPrefix("sercod-") {
		t.Error("Should not have sercod- prefix")
	}
}

func TestNrProtoc_Parse(t *testing.T) {
	tests := []struct {
		input    string
		wantPref string
		wantNum  int
		wantErr  bool
	}{
		{"sadm-0000001", "sadm-", 1, false},
		{"sercod-0000050", "sercod-", 50, false},
		{"invalid", "", 0, true},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			n, err := valueobjects.ParseNrProtoc(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("ParseNrProtoc() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !tt.wantErr {
				if n.Prefix() != tt.wantPref {
					t.Errorf("Prefix() = %v, want %v", n.Prefix(), tt.wantPref)
				}
				if n.Numero() != tt.wantNum {
					t.Errorf("Numero() = %v, want %v", n.Numero(), tt.wantNum)
				}
			}
		})
	}
}

func TestNrProtoc_String(t *testing.T) {
	n := valueobjects.NewNrProtoc("sadm-", 1)
	if n.String() != "sadm-0000001" {
		t.Errorf("String() = %v, want sadm-0000001", n.String())
	}
	
	n = valueobjects.NewNrProtoc("sercod-", 50)
	if n.String() != "sercod-0000050" {
		t.Errorf("String() = %v, want sercod-0000050", n.String())
	}
}