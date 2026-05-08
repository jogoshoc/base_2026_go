package valueobjects

import (
	"fmt"
	"strconv"
	"strings"
)

const (
	PrefixSAdm       = "sadm-"
	PrefixSercod     = "sercod-"
	PrefixSercodSAdm = "sercod_sadm-"
)

type NrProtoc struct {
	prefix string
	numero int
}

func NewNrProtoc(prefix string, numero int) *NrProtoc {
	return &NrProtoc{
		prefix: prefix,
		numero: numero,
	}
}

func ParseNrProtoc(s string) (*NrProtoc, error) {
	for _, p := range []string{PrefixSAdm, PrefixSercod, PrefixSercodSAdm} {
		if strings.HasPrefix(s, p) {
			numStr := strings.TrimPrefix(s, p)
			num, err := strconv.Atoi(numStr)
			if err != nil {
				return nil, err
			}
			return &NrProtoc{prefix: p, numero: num}, nil
		}
	}
	return nil, fmt.Errorf("nrprotoc inválido: %s", s)
}

func (n *NrProtoc) String() string {
	return fmt.Sprintf("%s%07d", n.prefix, n.numero)
}

func (n *NrProtoc) Prefix() string {
	return n.prefix
}

func (n *NrProtoc) Numero() int {
	return n.numero
}

func (n *NrProtoc) IsSAdm() bool {
	return n.prefix == PrefixSAdm
}

func (n *NrProtoc) IsSercod() bool {
	return n.prefix == PrefixSercod
}

func (n *NrProtoc) IsSercodSAdm() bool {
	return n.prefix == PrefixSercodSAdm
}