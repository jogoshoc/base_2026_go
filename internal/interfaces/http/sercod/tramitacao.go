package sercod

import (
	"net/http"
	"strconv"
	"time"

	"cgdoc/internal/application/cadastro"
	"cgdoc/internal/application/tramitacao"
	"cgdoc/internal/application/moviment"
	"cgdoc/internal/interfaces/middleware"
)

type TramitacaoHandler struct {
	service      *tramitacao.TramitacaoService
	cadastroSvc  *cadastro.CadastroService
}

func NewTramitacaoHandler(service *tramitacao.TramitacaoService, cadastroSvc *cadastro.CadastroService) *TramitacaoHandler {
	return &TramitacaoHandler{
		service:     service,
		cadastroSvc: cadastroSvc,
	}
}

func (h *TramitacaoHandler) List(w http.ResponseWriter, r *http.Request) {
	nrprotoc := r.URL.Query().Get("nrprotoc")
	if nrprotoc == "" {
		http.Error(w, "nrprotoc requerido", http.StatusBadRequest)
		return
	}

	tramitacoes, err := h.service.GetByNrProtoc(nrprotoc)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	html := `<!DOCTYPE html>
<html>
<head><title>Tramitações - SAdm</title></head>
<body>
<h1>Tramitações</h1>
<p>Processo: ` + nrprotoc + `</p>
<table border="1">
<tr><th>Código</th><th>Data</th><th>Origem</th><th>Destino</th><th>Prazo</th></tr>`

	for _, t := range tramitacoes {
		html += `<tr>
<td>` + t.CodMov + `</td>
<td>` + t.DtMovim.Format("02/01/2006 15:04") + `</td>
<td>` + t.OrigNome + `</td>
<td>` + t.DestNome + `</td>
<td>` + t.Prazo + `</td>
</tr>`
	}

	html += `</table>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`

	w.Write([]byte(html))
}

func (h *TramitacaoHandler) Add(w http.ResponseWriter, r *http.Request) {
	session, _ := middleware.GetSessionFromContext(r.Context())

	if r.Method == http.MethodGet {
		nrprotoc := r.URL.Query().Get("nrprotoc")
		html := `<!DOCTYPE html>
<html>
<head><title>Nova Tramitação - SAdm</title></head>
<body>
<h1>Nova Tramitação</h1>
<form method="post">
<input type="hidden" name="nrprotoc" value="` + nrprotoc + `">
<table>
<tr><td>Processo:</td><td>` + nrprotoc + `</td></tr>
<tr><td>Data:</td><td><input type="datetime-local" name="dtmovim" value="` + time.Now().Format("2006-01-02T15:04") + `"></td></tr>
<tr><td>Origem:</td><td><input type="text" name="orignome"></td></tr>
<tr><td>Destino:*</td><td><input type="text" name="destnome" required></td></tr>
<tr><td>Prazo:</td><td><input type="text" name="prazo"></td></tr>
<tr><td>Observações:</td><td><textarea name="obs"></textarea></td></tr>
</table>
<button type="submit">Enviar</button>
</form>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`
		w.Write([]byte(html))
		return
	}

	origNome := r.Form.Get("orignome")
	if origNome == "" {
		origNome = session.UserID
	}

	r.ParseForm()
	dtmovim, _ := time.Parse("2006-01-02T15:04", r.Form.Get("dtmovim"))

	req := &tramitacao.CreateRequest{
		NrProtoc: r.Form.Get("nrprotoc"),
		DtMovim:  dtmovim,
		OrigNome: origNome,
		DestNome: r.Form.Get("destnome"),
		Obs:      r.Form.Get("obs"),
		Prazo:    r.Form.Get("prazo"),
	}

	_, err := h.service.Create(req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	http.Redirect(w, r, "/tramitacao/list?nrprotoc="+r.Form.Get("nrprotoc"), http.StatusFound)
}

type MovimentHandler struct {
	service     *moviment.MovimentService
	cadastroSvc *cadastro.CadastroService
}

func NewMovimentHandler(service *moviment.MovimentService, cadastroSvc *cadastro.CadastroService) *MovimentHandler {
	return &MovimentHandler{
		service:     service,
		cadastroSvc: cadastroSvc,
	}
}

func (h *MovimentHandler) List(w http.ResponseWriter, r *http.Request) {
	nrprotoc := r.URL.Query().Get("nrprotoc")
	if nrprotoc == "" {
		http.Error(w, "nrprotoc requerido", http.StatusBadRequest)
		return
	}

	moviments, err := h.service.GetByNrProtoc(nrprotoc)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	html := `<!DOCTYPE html>
<html>
<head><title>Movimentações - SAdm</title></head>
<body>
<h1>Movimentações</h1>
<p>Processo: ` + nrprotoc + `</p>
<table border="1">
<tr><th>Código</th><th>Data</th><th>Usuário</th><th>Status</th></tr>`

	for _, m := range moviments {
		html += `<tr>
<td>` + m.CodMov + `</td>
<td>` + m.DtMovim.Format("02/01/2006 15:04") + `</td>
<td>` + m.UsuaMov + `</td>
<td>` + m.Cumprido + `</td>
</tr>`
	}

	html += `</table>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`

	w.Write([]byte(html))
}

func (h *MovimentHandler) Add(w http.ResponseWriter, r *http.Request) {
	session, _ := middleware.GetSessionFromContext(r.Context())

	if r.Method == http.MethodGet {
		nrprotoc := r.URL.Query().Get("nrprotoc")
		html := `<!DOCTYPE html>
<html>
<head><title>Nova Movimentação - SAdm</title></head>
<body>
<h1>Nova Movimentação</h1>
<form method="post">
<input type="hidden" name="nrprotoc" value="` + nrprotoc + `">
<table>
<tr><td>Processo:</td><td>` + nrprotoc + `</td></tr>
<tr><td>Data:</td><td><input type="datetime-local" name="dtmovim" value="` + time.Now().Format("2006-01-02T15:04") + `"></td></tr>
<tr><td>Usuário:</td><td>` + session.UserID + `</td></tr>
<tr><td>Status:</td><td><input type="text" name="cumprido"></td></tr>
<tr><td>Observações:</td><td><textarea name="obs"></textarea></td></tr>
</table>
<button type="submit">Registrar</button>
</form>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`
		w.Write([]byte(html))
		return
	}


	r.ParseForm()
	dtmovim, _ := time.Parse("2006-01-02T15:04", r.Form.Get("dtmovim"))

	req := &moviment.CreateRequest{
		NrProtoc: r.Form.Get("nrprotoc"),
		DtMovim:  dtmovim,
		Cumprido: r.Form.Get("cumprido"),
		Obs:      r.Form.Get("obs"),
	}

	_, err := h.service.Create(req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	http.Redirect(w, r, "/moviment/list?nrprotoc="+r.Form.Get("nrprotoc"), http.StatusFound)
}

func ensureInt(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}