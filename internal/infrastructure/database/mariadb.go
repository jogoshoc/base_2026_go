package database

import (
	"database/sql"

	"cgdoc/internal/domain/entities"
)

type MariaDB struct {
	DB *sql.DB
}

func NewMariaDB(db *sql.DB) *MariaDB {
	return &MariaDB{DB: db}
}

func (m *MariaDB) Usuario() UsuarioRepository {
	return &usuarioRepo{DB: m.DB}
}

func (m *MariaDB) Cadastro() CadastroRepository {
	return &cadastroRepo{DB: m.DB}
}

func (m *MariaDB) Tramitacao() TramitacaoRepository {
	return &tramitacaoRepo{DB: m.DB}
}

func (m *MariaDB) Moviment() MovimentRepository {
	return &movimentRepo{DB: m.DB}
}

type usuarioRepo struct {
	DB *sql.DB
}

func (r *usuarioRepo) FindByNrUsuario(nrUsuario string) (*entities.Usuario, error) {
	var u entities.Usuario
	err := r.DB.QueryRow(
		"SELECT codigo, nr_usuario, pg, nome, ramal, unidade, secao, privilegio FROM usuarios WHERE nr_usuario = ?",
		nrUsuario,
	).Scan(&u.Codigo, &u.NrUsuario, &u.PG, &u.Nome, &u.Ramal, &u.Unidade, &u.Secao, &u.Privilegio)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &u, nil
}

func (r *usuarioRepo) FindByID(codigo int) (*entities.Usuario, error) {
	var u entities.Usuario
	err := r.DB.QueryRow(
		"SELECT codigo, nr_usuario, pg, nome, ramal, unidade, secao, privilegio FROM usuarios WHERE codigo = ?",
		codigo,
	).Scan(&u.Codigo, &u.NrUsuario, &u.PG, &u.Nome, &u.Ramal, &u.Unidade, &u.Secao, &u.Privilegio)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &u, nil
}

func (r *usuarioRepo) Create(u *entities.Usuario) error {
	result, err := r.DB.Exec(
		"INSERT INTO usuarios (nr_usuario, pg, nome, ramal, unidade, secao, senha, privilegio) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
		u.NrUsuario, u.PG, u.Nome, u.Ramal, u.Unidade, u.Secao, u.Senha, u.Privilegio,
	)
	if err != nil {
		return err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}
	u.Codigo = int(id)
	return nil
}

func (r *usuarioRepo) Update(u *entities.Usuario) error {
	_, err := r.DB.Exec(
		"UPDATE usuarios SET pg = ?, nome = ?, ramal = ?, unidade = ?, secao = ?, senha = ?, privilegio = ? WHERE codigo = ?",
		u.PG, u.Nome, u.Ramal, u.Unidade, u.Secao, u.Senha, u.Privilegio, u.Codigo,
	)
	return err
}

func (r *usuarioRepo) Delete(codigo int) error {
	_, err := r.DB.Exec("DELETE FROM usuarios WHERE codigo = ?", codigo)
	return err
}

func (r *usuarioRepo) ListAll() ([]*entities.Usuario, error) {
	rows, err := r.DB.Query("SELECT codigo, nr_usuario, pg, nome, ramal, unidade, secao, privilegio FROM usuarios")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var usuarios []*entities.Usuario
	for rows.Next() {
		var u entities.Usuario
		if err := rows.Scan(&u.Codigo, &u.NrUsuario, &u.PG, &u.Nome, &u.Ramal, &u.Unidade, &u.Secao, &u.Privilegio); err != nil {
			return nil, err
		}
		usuarios = append(usuarios, &u)
	}
	return usuarios, nil
}

type cadastroRepo struct {
	DB *sql.DB
}

func (r *cadastroRepo) FindByNrProtoc(nrprotoc string) (*entities.Cadastro, error) {
	var c entities.Cadastro
	err := r.DB.QueryRow(
		"SELECT controle, nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp FROM cadastro WHERE nrprotoc = ?",
		nrprotoc,
	).Scan(&c.Controle, &c.NrProtoc, &c.DtEntr, &c.Descr, &c.Emissor, &c.Nome, &c.Assunto, &c.TipoDoc, &c.Nat, &c.Destino, &c.Obs, &c.Usuario, &c.PastaArquiv, &c.CPF, &c.MASP)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &c, nil
}

func (r *cadastroRepo) FindByID(controle int) (*entities.Cadastro, error) {
	var c entities.Cadastro
	err := r.DB.QueryRow(
		"SELECT controle, nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp FROM cadastro WHERE controle = ?",
		controle,
	).Scan(&c.Controle, &c.NrProtoc, &c.DtEntr, &c.Descr, &c.Emissor, &c.Nome, &c.Assunto, &c.TipoDoc, &c.Nat, &c.Destino, &c.Obs, &c.Usuario, &c.PastaArquiv, &c.CPF, &c.MASP)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &c, nil
}

func (r *cadastroRepo) Create(c *entities.Cadastro) error {
	result, err := r.DB.Exec(
		"INSERT INTO cadastro (nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
		c.NrProtoc, c.DtEntr, c.Descr, c.Emissor, c.Nome, c.Assunto, c.TipoDoc, c.Nat, c.Destino, c.Obs, c.Usuario, c.PastaArquiv, c.CPF, c.MASP,
	)
	if err != nil {
		return err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}
	c.Controle = int(id)
	return nil
}

func (r *cadastroRepo) Update(c *entities.Cadastro) error {
	_, err := r.DB.Exec(
		"UPDATE cadastro SET nrprotoc = ?, dtentr = ?, descr = ?, emissor = ?, nome = ?, assunto = ?, tipodoc = ?, nat = ?, destino = ?, obs = ?, usuario = ?, pastaarquiv = ?, cpf = ?, masp = ? WHERE controle = ?",
		c.NrProtoc, c.DtEntr, c.Descr, c.Emissor, c.Nome, c.Assunto, c.TipoDoc, c.Nat, c.Destino, c.Obs, c.Usuario, c.PastaArquiv, c.CPF, c.MASP, c.Controle,
	)
	return err
}

func (r *cadastroRepo) Delete(controle int) error {
	_, err := r.DB.Exec("DELETE FROM cadastro WHERE controle = ?", controle)
	return err
}

func (r *cadastroRepo) Search(params map[string]interface{}) ([]*entities.Cadastro, error) {
	// Basic implementation - can be enhanced with dynamic query building
	return nil, nil
}

func (r *cadastroRepo) ListByPrefix(prefix string, limit, offset int) ([]*entities.Cadastro, error) {
	rows, err := r.DB.Query(
		"SELECT controle, nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp FROM cadastro WHERE nrprotoc LIKE ? ORDER BY nrprotoc DESC LIMIT ? OFFSET ?",
		prefix+"%", limit, offset,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var cadastros []*entities.Cadastro
	for rows.Next() {
		var c entities.Cadastro
		if err := rows.Scan(&c.Controle, &c.NrProtoc, &c.DtEntr, &c.Descr, &c.Emissor, &c.Nome, &c.Assunto, &c.TipoDoc, &c.Nat, &c.Destino, &c.Obs, &c.Usuario, &c.PastaArquiv, &c.CPF, &c.MASP); err != nil {
			return nil, err
		}
		cadastros = append(cadastros, &c)
	}
	return cadastros, nil
}

func (r *cadastroRepo) Count() (int, error) {
	var count int
	err := r.DB.QueryRow("SELECT COUNT(*) FROM cadastro").Scan(&count)
	return count, err
}

type tramitacaoRepo struct {
	DB *sql.DB
}

func (r *tramitacaoRepo) FindByNrProtoc(nrprotoc string) ([]*entities.Tramitacao, error) {
	rows, err := r.DB.Query(
		"SELECT codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, emissor, assunto, tipodoc, descr, nome, dtentr FROM tramitacao WHERE nrprotoc = ? ORDER BY dtmovim DESC",
		nrprotoc,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tramitacoes []*entities.Tramitacao
	for rows.Next() {
		var t entities.Tramitacao
		if err := rows.Scan(&t.CodMov, &t.NrProtoc, &t.DtMovim, &t.OrigNome, &t.DestNome, &t.Obs, &t.Prazo, &t.Emissor, &t.Assunto, &t.TipoDoc, &t.Descr, &t.Nome, &t.DtEntr); err != nil {
			return nil, err
		}
		tramitacoes = append(tramitacoes, &t)
	}
	return tramitacoes, nil
}

func (r *tramitacaoRepo) FindByID(codmov string) (*entities.Tramitacao, error) {
	var t entities.Tramitacao
	err := r.DB.QueryRow(
		"SELECT codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, emissor, assunto, tipodoc, descr, nome, dtentr FROM tramitacao WHERE codmov = ?",
		codmov,
	).Scan(&t.CodMov, &t.NrProtoc, &t.DtMovim, &t.OrigNome, &t.DestNome, &t.Obs, &t.Prazo, &t.Emissor, &t.Assunto, &t.TipoDoc, &t.Descr, &t.Nome, &t.DtEntr)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *tramitacaoRepo) Create(t *entities.Tramitacao) error {
	_, err := r.DB.Exec(
		"INSERT INTO tramitacao (codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, emissor, assunto, tipodoc, descr, nome, dtentr) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
		t.CodMov, t.NrProtoc, t.DtMovim, t.OrigNome, t.DestNome, t.Obs, t.Prazo, t.Emissor, t.Assunto, t.TipoDoc, t.Descr, t.Nome, t.DtEntr,
	)
	return err
}

func (r *tramitacaoRepo) Update(t *entities.Tramitacao) error {
	_, err := r.DB.Exec(
		"UPDATE tramitacao SET nrprotoc = ?, dtmovim = ?, orignome = ?, destnome = ?, obs = ?, prazo = ?, emissor = ?, assunto = ?, tipodoc = ?, descr = ?, nome = ?, dtentr = ? WHERE codmov = ?",
		t.NrProtoc, t.DtMovim, t.OrigNome, t.DestNome, t.Obs, t.Prazo, t.Emissor, t.Assunto, t.TipoDoc, t.Descr, t.Nome, t.DtEntr, t.CodMov,
	)
	return err
}

func (r *tramitacaoRepo) Delete(codmov string) error {
	_, err := r.DB.Exec("DELETE FROM tramitacao WHERE codmov = ?", codmov)
	return err
}

type movimentRepo struct {
	DB *sql.DB
}

func (r *movimentRepo) FindByNrProtoc(nrprotoc string) ([]*entities.Moviment, error) {
	rows, err := r.DB.Query(
		"SELECT codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, usua_mov, cumprido FROM moviment WHERE nrprotoc = ? ORDER BY dtmovim DESC",
		nrprotoc,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var movimentacoes []*entities.Moviment
	for rows.Next() {
		var m entities.Moviment
		if err := rows.Scan(&m.CodMov, &m.NrProtoc, &m.DtMovim, &m.OrigNome, &m.DestNome, &m.Obs, &m.Prazo, &m.UsuaMov, &m.Cumprido); err != nil {
			return nil, err
		}
		movimentacoes = append(movimentacoes, &m)
	}
	return movimentacoes, nil
}

func (r *movimentRepo) FindByID(codmov string) (*entities.Moviment, error) {
	var m entities.Moviment
	err := r.DB.QueryRow(
		"SELECT codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, usua_mov, cumprido FROM moviment WHERE codmov = ?",
		codmov,
	).Scan(&m.CodMov, &m.NrProtoc, &m.DtMovim, &m.OrigNome, &m.DestNome, &m.Obs, &m.Prazo, &m.UsuaMov, &m.Cumprido)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &m, nil
}

func (r *movimentRepo) Create(m *entities.Moviment) error {
	_, err := r.DB.Exec(
		"INSERT INTO moviment (codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, usua_mov, cumprido) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
		m.CodMov, m.NrProtoc, m.DtMovim, m.OrigNome, m.DestNome, m.Obs, m.Prazo, m.UsuaMov, m.Cumprido,
	)
	return err
}

func (r *movimentRepo) Update(m *entities.Moviment) error {
	_, err := r.DB.Exec(
		"UPDATE moviment SET nrprotoc = ?, dtmovim = ?, orignome = ?, destnome = ?, obs = ?, prazo = ?, usua_mov = ?, cumprido = ? WHERE codmov = ?",
		m.NrProtoc, m.DtMovim, m.OrigNome, m.DestNome, m.Obs, m.Prazo, m.UsuaMov, m.Cumprido, m.CodMov,
	)
	return err
}

func (r *movimentRepo) Delete(codmov string) error {
	_, err := r.DB.Exec("DELETE FROM moviment WHERE codmov = ?", codmov)
	return err
}

func OpenMariaDB(dsn string) (*sql.DB, error) {
	return sql.Open("mysql", dsn)
}

func InitSchema(db *sql.DB) error {
	// This will be replaced by migrations
	return nil
}