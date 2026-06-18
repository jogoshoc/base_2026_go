-- ============================================================
-- ETL: Migração de dados do schema legado (Access) → schema Go
-- Deve ser executado APÓS 001_initial_schema.sql criar as tabelas
--
-- Lê tabelas no formato Access (PascalCase, acentos)
-- Transforma para o formato Go (lowercase, prefixos, VARCHAR)
-- ============================================================
SET @db_name = (SELECT DATABASE());
SET @prefix = CASE
    WHEN @db_name = 'movedb_SAdm' THEN 'sadm-'
    WHEN @db_name = 'movedb_Sercod' THEN 'sercod-'
    WHEN @db_name = 'movedb_Sercod_SAdm' THEN 'sercod_sadm-'
    ELSE 'unknown-'
END;

SELECT CONCAT('ETL: ', @db_name, ' (prefixo: ', @prefix, ')') AS status;

-- ============================================================
-- 1. usuarios: Usuários → usuarios
-- ============================================================
-- Nota: codigo é AUTO_INCREMENT, não incluído no INSERT
INSERT IGNORE INTO usuarios (nr_usuario, pg, nome, ramal, unidade, secao, senha, privilegio, fotografia)
SELECT
    TRIM(`NúmeroDoUsuário`),
    TRIM(`PG`),
    TRIM(`Nome`),
    TRIM(`Ramal`),
    TRIM(`Unidade`),
    TRIM(`Seção`),
    COALESCE(TRIM(`Senha`), 'trocar_senha'),
    CASE LOWER(TRIM(`Privilegio`))
        WHEN 'adm' THEN 'adm'
        WHEN 'vis' THEN 'vis'
        ELSE 'user'
    END,
    `Fotografia`
FROM `Usuários`;

SELECT CONCAT('  usuarios: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 2. cadastro: Cadastro → cadastro
--    NrProtoc INT → VARCHAR com prefixo do banco
-- ============================================================
INSERT IGNORE INTO cadastro (controle, nrprotoc, dtentr, descr, emissor, nome, assunto, tipodoc, nat, destino, obs, usuario, pastaarquiv, cpf, masp)
SELECT
    `Controle`,
    CONCAT(@prefix, `NrProtoc`),
    `DtEntr`,
    COALESCE(TRIM(`Descr`), ''),
    COALESCE(TRIM(`Emissor`), ''),
    COALESCE(TRIM(`Nome`), ''),
    COALESCE(TRIM(`Assunto`), ''),
    COALESCE(TRIM(`TipoDoc`), ''),
    COALESCE(TRIM(`Nat`), ''),
    COALESCE(TRIM(`Destino`), ''),
    `Obs`,
    TRIM(`Usuario`),
    TRIM(`PastaArquiv`),
    TRIM(`CPF`),
    TRIM(`MASP`)
FROM `Cadastro`;

SELECT CONCAT('  cadastro: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 3. moviment: Moviment → moviment
--    CodMov INT → VARCHAR('MV-{id}'), NrProtoc INT → VARCHAR com prefixo
--    Prazo DATETIME → VARCHAR formatado
-- ============================================================
INSERT IGNORE INTO moviment (codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, usua_mov, cumprido)
SELECT
    CONCAT('MV-', `CodMov`),
    CONCAT(@prefix, `NrProtoc`),
    `DtMovim`,
    TRIM(`OrigNome`),
    TRIM(`DestNome`),
    `Obs`,
    CASE WHEN `Prazo` IS NOT NULL THEN DATE_FORMAT(`Prazo`, '%Y-%m-%d') ELSE NULL END,
    TRIM(`UsuaMov`),
    TRIM(`Cumprido`)
FROM `Moviment`;

SELECT CONCAT('  moviment: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 4. tramitacao: Moviment JOIN Cadastro → tramitacao
--    Enriquecido: emissor, assunto, tipodoc, descr, nome, dtentr
--    CodMov usa prefixo 'TM-' para diferenciar de moviment
-- ============================================================
INSERT IGNORE INTO tramitacao (codmov, nrprotoc, dtmovim, orignome, destnome, obs, prazo, emissor, assunto, tipodoc, descr, nome, dtentr)
SELECT
    CONCAT('TM-', m.`CodMov`),
    CONCAT(@prefix, m.`NrProtoc`),
    m.`DtMovim`,
    TRIM(m.`OrigNome`),
    TRIM(m.`DestNome`),
    m.`Obs`,
    CASE WHEN m.`Prazo` IS NOT NULL THEN DATE_FORMAT(m.`Prazo`, '%Y-%m-%d') ELSE NULL END,
    COALESCE(TRIM(c.`Emissor`), ''),
    COALESCE(TRIM(c.`Assunto`), ''),
    COALESCE(TRIM(c.`TipoDoc`), ''),
    COALESCE(TRIM(c.`Descr`), ''),
    COALESCE(TRIM(c.`Nome`), ''),
    c.`DtEntr`
FROM `Moviment` m
LEFT JOIN `Cadastro` c ON c.`NrProtoc` = m.`NrProtoc`;

SELECT CONCAT('  tramitacao: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 5. orgaos: Orgaos → orgaos
-- ============================================================
INSERT IGNORE INTO orgaos (orgao)
SELECT DISTINCT TRIM(`Orgao`) FROM `Orgaos`
WHERE `Orgao` IS NOT NULL AND TRIM(`Orgao`) != '';

SELECT CONCAT('  orgaos: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 6. tipodoc: Tipodoc → tipodoc
-- ============================================================
INSERT IGNORE INTO tipodoc (tipodoc)
SELECT DISTINCT TRIM(`TipoDoc`) FROM `Tipodoc`
WHERE `TipoDoc` IS NOT NULL AND TRIM(`TipoDoc`) != '';

SELECT CONCAT('  tipodoc: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- 7. acesso: acesso (legado) → acesso
-- ============================================================
INSERT IGNORE INTO acesso (nr_usuario, data_hora)
SELECT
    TRIM(`NrUsuário`),
    COALESCE(`DataAcesso`, NOW())
FROM `acesso_legado`
WHERE `NrUsuário` IS NOT NULL AND TRIM(`NrUsuário`) != '';

SELECT CONCAT('  acesso: ', ROW_COUNT(), ' registros') AS status;

-- ============================================================
-- Relatório final
-- ============================================================
SELECT CONCAT(
    'RELOGIO ', @db_name, ': ',
    'cadastro=', (SELECT COUNT(*) FROM cadastro),
    ' usuarios=', (SELECT COUNT(*) FROM usuarios),
    ' moviment=', (SELECT COUNT(*) FROM moviment),
    ' tramitacao=', (SELECT COUNT(*) FROM tramitacao),
    ' orgaos=', (SELECT COUNT(*) FROM orgaos),
    ' tipodoc=', (SELECT COUNT(*) FROM tipodoc),
    ' acesso=', (SELECT COUNT(*) FROM acesso)
) AS relatorio;
