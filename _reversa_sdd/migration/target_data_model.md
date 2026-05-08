# Target Data Model — Projeto CGDoc

> Gerado pelo Reversa Designer em 2026-05-07 (Fase 2)

## Entidades de Dados

### usuários

| Campo | Tipo | PK | UK | Não Nulo | Default | Origem |
|-------|------|----|----|----------|---------|--------|
| código | INT | ✅ | | ✅ | AUTO_INCREMENT | `Usuários.Código` |
| nr_usuário | VARCHAR(8) | | ✅ | ✅ | | `Usuários.NúmeroDoUsuário` |
| pg | VARCHAR(7) | | | | | `Usuários.PG` |
| nome | VARCHAR(50) | | | | | `Usuários.Nome` |
| ramal | VARCHAR(4) | | | | | `Usuários.Ramal` |
| unidade | VARCHAR(50) | | | | | `Usuários.Unidade` |
| seção | VARCHAR(15) | | | ✅ | | `Usuários.Seção` |
| fotografia | LONGBLOB | | | | | `Usuários.Fotografia` |
| senha | VARCHAR(8) | | | ✅ | | `Usuários.Senha` |
| privilegio | VARCHAR(50) | | | ✅ | 'user' | `Usuários.Privilegio` |

**Índices:**
- `idx_usuario_secao` ON `seção`

---

### cadastro

| Campo | Tipo | PK | UK | Não Nulo | Default | Origem |
|-------|------|----|----|----------|---------|--------|
| controle | INT | ✅ | | ✅ | AUTO_INCREMENT | `Cadastro.Controle` |
| nrprotoc | BIGINT | | ✅ | ✅ | | `Cadastro.NrProtoc` |
| dtentr | DATETIME | | | ✅ | | `Cadastro.DtEntr` |
| descr | VARCHAR(100) | | | ✅ | | `Cadastro.Descr` |
| emissor | VARCHAR(50) | | | ✅ | | `Cadastro.Emissor` |
| nome | VARCHAR(255) | | | ✅ | | `Cadastro.Nome` |
| assunto | VARCHAR(255) | | | ✅ | | `Cadastro.Assunto` |
| tipodoc | VARCHAR(50) | | | ✅ | | `Cadastro.TipoDoc` |
| nat | VARCHAR(10) | | | ✅ | | `Cadastro.Nat` |
| destino | VARCHAR(50) | | | ✅ | | `Cadastro.Destino` |
| obs | LONGTEXT | | | | | `Cadastro.Obs` |
| usuario | VARCHAR(50) | | | | | `Cadastro.Usuario` |
| pastaarquiv | VARCHAR(50) | | | | | `Cadastro.PastaArquiv` |
| cpf | VARCHAR(11) | | | | | `Cadastro.CPF` |
| masp | VARCHAR(10) | | | | | `Cadastro.MASP` |

**Índices:**
- `idx_cadastro_nrprotoc` ON `nrprotoc` (UNIQUE)
- `idx_cadastro_usuario` ON `usuario`

---

### tramitacao

| Campo | Tipo | PK | UK | Não Nulo | Default | Origem |
|-------|------|----|----|----------|---------|--------|
| codmov | VARCHAR(50) | ✅ | | ✅ | | `Tramitação.CodMov` |
| nrprotoc | BIGINT | | | ✅ | | `Tramitação.NrProtoc` |
| dtmovim | DATETIME | | | ✅ | | `Tramitação.DtMovim` |
| orignome | VARCHAR(50) | | | | | `Tramitação.OrigNome` |
| destnome | VARCHAR(50) | | | ✅ | | `Tramitação.DestNome` |
| obs | LONGTEXT | | | | | `Tramitação.Obs` |
| prazo | VARCHAR(50) | | | | | `Tramitação.Prazo` |
| emissor | VARCHAR(50) | | | | | `Tramitação.Emissor` |
| assunto | VARCHAR(255) | | | | | `Tramitação.Assunto` |
| tipodoc | VARCHAR(50) | | | | | `Tramitação.TipoDoc` |
| descr | VARCHAR(100) | | | | | `Tramitação.Descr` |
| nome | VARCHAR(255) | | | | | `Tramitação.Nome` |
| dtentr | DATETIME | | | | | `Tramitação.DtEntr` |

**Índices:**
- `idx_tramitacao_nrprotoc` ON `nrprotoc`

**FK:**
- `nrprotoc` → `cadastro.nrprotoc`

---

### moviment

| Campo | Tipo | PK | UK | Não Nulo | Default | Origem |
|-------|------|----|----|----------|---------|--------|
| codmov | VARCHAR(50) | ✅ | | ✅ | | `Movimentação.CodMov` |
| nrprotoc | BIGINT | | | ✅ | | `Movimentação.NrProtoc` |
| dtmovim | DATETIME | | | ✅ | | `Movimentação.DtMovim` |
| orignome | VARCHAR(50) | | | | | `Movimentação.OrigNome` |
| destnome | VARCHAR(50) | | | | | `Movimentação.DestNome` |
| obs | LONGTEXT | | | | | | `Movimentação.Obs` |
| prazo | VARCHAR(50) | | | | | `Movimentação.Prazo` |
| usua_mov | VARCHAR(50) | | | | | `Movimentação.UsuaMov` |
| cumprido | VARCHAR(50) | | | | | | `Movimentação.Cumprido` |

**Índices:**
- `idx_moviment_nrprotoc` ON `nrprotoc`

**FK:**
- `nrprotoc` → `cadastro.nrprotoc`

---

## DDL Completo

```sql
CREATE TABLE IF NOT EXISTS `usuarios` (
  `codigo` INT NOT NULL AUTO_INCREMENT,
  `nr_usuário` VARCHAR(8) NOT NULL,
  `pg` VARCHAR(7),
  `nome` VARCHAR(50),
  `ramal` VARCHAR(4),
  `unidade` VARCHAR(50),
  `seção` VARCHAR(15) NOT NULL,
  `fotografia` LONGBLOB,
  `senha` VARCHAR(8) NOT NULL,
  `privilegio` VARCHAR(50) NOT NULL DEFAULT 'user',
  PRIMARY KEY (`codigo`),
  UNIQUE KEY `uk_usuario_nr` (`nr_usuário`),
  KEY `idx_usuario_seção` (`seção`)
) ENGINE=maria DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cadastro` (
  `controle` INT NOT NULL AUTO_INCREMENT,
  `nrprotoc` BIGINT NOT NULL,
  `dtentr` DATETIME NOT NULL,
  `descr` VARCHAR(100) NOT NULL,
  `emissor` VARCHAR(50) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `assunto` VARCHAR(255) NOT NULL,
  `tipodoc` VARCHAR(50) NOT NULL,
  `nat` VARCHAR(10) NOT NULL,
  `destino` VARCHAR(50) NOT NULL,
  `obs` LONGTEXT,
  `usuario` VARCHAR(50),
  `pastaarquiv` VARCHAR(50),
  `cpf` VARCHAR(11),
  `masp` VARCHAR(10),
  PRIMARY KEY (`controle`),
  UNIQUE KEY `uk_cadastro_nrprotoc` (`nrprotoc`),
  KEY `idx_cadastro_usuario` (`usuario`)
) ENGINE=maria DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tramitacao` (
  `codmov` VARCHAR(50) NOT NULL,
  `nrprotoc` BIGINT NOT NULL,
  `dtmovim` DATETIME NOT NULL,
  `orignome` VARCHAR(50),
  `destnome` VARCHAR(50) NOT NULL,
  `obs` LONGTEXT,
  `prazo` VARCHAR(50),
  `emissor` VARCHAR(50),
  `assunto` VARCHAR(255),
  `tipodoc` VARCHAR(50),
  `descr` VARCHAR(100),
  `nome` VARCHAR(255),
  `dtentr` DATETIME,
  PRIMARY KEY (`codmov`),
  KEY `idx_tramitacao_nrprotoc` (`nrprotoc`),
  FOREIGN KEY (`nrprotoc`) REFERENCES `cadastro`(`nrprotoc`)
) ENGINE=maria DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `moviment` (
  `codmov` VARCHAR(50) NOT NULL,
  `nrprotoc` BIGINT NOT NULL,
  `dtmovim` DATETIME NOT NULL,
  `orignome` VARCHAR(50),
  `destnome` VARCHAR(50),
  `obs` LONGTEXT,
  `prazo` VARCHAR(50),
  `usua_mov` VARCHAR(50),
  `cumprido` VARCHAR(50),
  PRIMARY KEY (`codmov`),
  KEY `idx_moviment_nrprotoc` (`nrprotoc`),
  FOREIGN KEY (`nrprotoc`) REFERENCES `cadastro`(`nrprotoc`)
) ENGINE=maria DEFAULT CHARSET=utf8;
```

---

## Origem no Legado

| Tabela Nova | Tabela Legado | Transformação |
|-------------|---------------|----------------|
| `usuarios` | `Usuários` | Renomeada |
| `cadastro` | `Cadastro` | 1-para-1 |
| `tramitacao` | `Tramitação` | 1-para-1 |
| `moviment` | `Movimentação` | 1-para-1 |

---

## Considerações

- **Paradigma Go:** Não há necessidade de outbox pattern (sistema não é event-driven)
- **Consistência:** FK com cascade não habilitado (legado não tinha, manter paridade)
- **Índices:** Mesmo do legado para performance idêntica
- **Charset:** UTF-8 para suportar caracteres brasileiros