package sadm

import (
	"net/http"
	"strconv"
	"time"

	"cgdoc/internal/application/cadastro"
	"cgdoc/internal/domain/entities"
	"cgdoc/internal/interfaces/middleware"
)

type CadastroHandler struct {
	service *cadastro.CadastroService
}

func NewCadastroHandler(service *cadastro.CadastroService) *CadastroHandler {
	return &CadastroHandler{service: service}
}

func (h *CadastroHandler) List(w http.ResponseWriter, r *http.Request) {
	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	if page < 1 {
		page = 1
	}

	cadastros, total, err := h.service.List(page, 20)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Simple HTML list
	html := `<!DOCTYPE html>
<html>
<head><title>Cadastros - SAdm</title></head>
<body>
<h1>Cadastros</h1>
<table border="1">
<tr><th>NrProtoc</th><th>Data</th><th>Descrição</th><th>Nome</th><th>Destino</th><th>Ações</th></tr>`

	for _, c := range cadastros {
		html += `<tr>
<td>` + c.NrProtoc + `</td>
<td>` + c.DtEntr.Format("02/01/2006") + `</td>
<td>` + c.Descr + `</td>
<td>` + c.Nome + `</td>
<td>` + c.Destino + `</td>
<td><a href="/cadastro/edit?controle=` + strconv.Itoa(c.Controle) + `">Editar</a></td>
</tr>`
	}

	html += `</table>
<p>Total: ` + strconv.Itoa(total) + `</p>
<p><a href="/cadastro/add">Novo Cadastro</a> | <a href="/menu">Voltar</a></p>
</body>
</html>`

	w.Write([]byte(html))
}

func (h *CadastroHandler) Add(w http.ResponseWriter, r *http.Request) {
	session, _ := middleware.GetSessionFromContext(r.Context())

	if r.Method == http.MethodGet {
		html := `<!DOCTYPE html>
<html>
<head><title>Novo Cadastro - SAdm</title></head>
<body>
<h1>Novo Cadastro</h1>
<form method="post">
<table>
<tr><td>Data Entrada:</td><td><input type="datetime-local" name="dtentr" value="` + time.Now().Format("2006-01-02T15:04") + `" required></td></tr>
<tr><td>Descrição:</td><td><input type="text" name="descr" required></td></tr>
<tr><td>Emissor:</td><td><input type="text" name="emissor" required></td></tr>
<tr><td>Nome:</td><td><input type="text" name="nome" required></td></tr>
<tr><td>Assunto:</td><td><input type="text" name="assunto" required></td></tr>
<tr><td>Tipo Doc:</td><td><input type="text" name="tipodoc" required></td></tr>
<tr><td>Natureza:</td><td><input type="text" name="nat" value="Entrada" required></td></tr>
<tr><td>Destino:</td><td><input type="text" name="destino" required></td></tr>
<tr><td>CPF:</td><td><input type="text" name="cpf"></td></tr>
<tr><td>MASP:</td><td><input type="text" name="masp"></td></tr>
<tr><td>Observações:</td><td><textarea name="obs"></textarea></td></tr>
</table>
<button type="submit">Salvar</button>
</form>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`
		w.Write([]byte(html))
		return
	}

	// Handle POST
	r.ParseForm()
	dtentr, _ := time.Parse("2006-01-02T15:04", r.Form.Get("dtentr"))

	req := &cadastro.CreateRequest{
		DtEntr:  dtentr,
		Descr:   r.Form.Get("descr"),
		Emissor: r.Form.Get("emissor"),
		Nome:    r.Form.Get("nome"),
		Assunto: r.Form.Get("assunto"),
		TipoDoc: r.Form.Get("tipodoc"),
		Nat:     r.Form.Get("nat"),
		Destino: r.Form.Get("destino"),
		Obs:     r.Form.Get("obs"),
		CPF:     r.Form.Get("cpf"),
		MASP:    r.Form.Get("masp"),
		Usuario: session.UserID,
	}

	_, err := h.service.Create(req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	http.Redirect(w, r, "/cadastro/list", http.StatusFound)
}

func (h *CadastroHandler) Edit(w http.ResponseWriter, r *http.Request) {
	controle, _ := strconv.Atoi(r.URL.Query().Get("controle"))

	if r.Method == http.MethodGet {
		c, err := h.service.GetByID(controle)
		if err != nil || c == nil {
			http.Error(w, "Não encontrado", http.StatusNotFound)
			return
		}

		html := `<!DOCTYPE html>
<html>
<head><title>Editar Cadastro - SAdm</title></head>
<body>
<h1>Editar Cadastro</h1>
<form method="post">
<input type="hidden" name="controle" value="` + strconv.Itoa(c.Controle) + `">
<table>
<tr><td>NrProtoc:</td><td>` + c.NrProtoc + `</td></tr>
<tr><td>Descrição:</td><td><input type="text" name="descr" value="` + c.Descr + `"></td></tr>
<tr><td>Nome:</td><td><input type="text" name="nome" value="` + c.Nome + `"></td></tr>
<tr><td>Assunto:</td><td><input type="text" name="assunto" value="` + c.Assunto + `"></td></tr>
<tr><td>Destino:</td><td><input type="text" name="destino" value="` + c.Destino + `"></td></tr>
<tr><td>Observações:</td><td><textarea name="obs">` + c.Obs + `</textarea></td></tr>
</table>
<button type="submit">Salvar</button>
</form>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`
		w.Write([]byte(html))
		return
	}

	// Handle POST
	r.ParseForm()
	controle, _ = strconv.Atoi(r.Form.Get("controle"))

	req := &cadastro.UpdateRequest{
		Descr:   r.Form.Get("descr"),
		Nome:    r.Form.Get("nome"),
		Assunto: r.Form.Get("assunto"),
		Destino: r.Form.Get("destino"),
		Obs:     r.Form.Get("obs"),
	}

	_, err := h.service.Update(controle, req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	http.Redirect(w, r, "/cadastro/list", http.StatusFound)
}

func (h *CadastroHandler) Search(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()

	params := cadastro.SearchParams{
		NrProtoc: r.Form.Get("nrprotoc"),
		Nome:     r.Form.Get("nome"),
		Assunto:  r.Form.Get("assunto"),
		Emissor:  r.Form.Get("emissor"),
		Destino:  r.Form.Get("destino"),
		Nat:      r.Form.Get("nat"),
		TipoDoc:  r.Form.Get("tipodoc"),
	}

	cadastros, err := h.service.Search(params)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Render results
	html := `<!DOCTYPE html>
<html>
<head><title>Busca - SAdm</title></head>
<body>
<h1>Resultados da Busca</h1>
<table border="1">
<tr><th>NrProtoc</th><th>Descrição</th><th>Nome</th><th>Ações</th></tr>`

	for _, c := range cadastros {
		html += `<tr>
<td>` + c.NrProtoc + `</td>
<td>` + c.Descr + `</td>
<td>` + c.Nome + `</td>
<td><a href="/cadastro/edit?controle=` + strconv.Itoa(c.Controle) + `">Editar</a></td>
</tr>`
	}

	html += `</table>
<p><a href="/cadastro/list">Voltar</a></p>
</body>
</html>`

	w.Write([]byte(html))
}

func (h *CadastroHandler) Delete(w http.ResponseWriter, r *http.Request) {
	controle, _ := strconv.Atoi(r.URL.Query().Get("controle"))

	err := h.service.Delete(controle)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	http.Redirect(w, r, "/cadastro/list", http.StatusFound)
}

func (h *CadastroHandler) RegisterRoutes(r interface{ Mount(path string, handler interface{}) }) {
	r.Mount("/cadastro/list", http.HandlerFunc(h.List))
	r.Mount("/cadastro/add", http.HandlerFunc(h.Add))
	r.Mount("/cadastro/edit", http.HandlerFunc(h.Edit))
	r.Mount("/cadastro/search", http.HandlerFunc(h.Search))
	r.Mount("/cadastro/delete", http.HandlerFunc(h.Delete))
}

func ensureHandlerFunc(h func(http.ResponseWriter, *http.Request)) http.Handler {
	return http.HandlerFunc(h)
}