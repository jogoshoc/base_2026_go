-- Migration 001: Schema inicial do sistema CGDoc
-- Baseado no legado ASP + Access, adaptado para Go + MariaDB
-- Tabelas com prefixo NrProtoc (sadm-/sercod-) e CodMov em string

-- ============================================================
-- Tabela: usuarios
-- Mapeamento da tabela legada "Usuários"
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nr_usuario VARCHAR(20) NOT NULL UNIQUE,
    pg VARCHAR(10),
    nome VARCHAR(100) NOT NULL,
    ramal VARCHAR(10),
    unidade VARCHAR(100),
    secao VARCHAR(50),
    senha VARCHAR(255) NOT NULL,
    privilegio ENUM('adm', 'user', 'vis') NOT NULL DEFAULT 'user',
    fotografia LONGBLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nr_usuario (nr_usuario),
    INDEX idx_unidade (unidade),
    INDEX idx_secao (secao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: cadastro
-- Mapeamento da tabela legada "Cadastro"
-- NrProtoc mudou de INTEGER para VARCHAR com prefixo (sadm-/sercod-)
-- ============================================================
CREATE TABLE IF NOT EXISTS cadastro (
    controle INT AUTO_INCREMENT PRIMARY KEY,
    nrprotoc VARCHAR(30) NOT NULL UNIQUE,
    dtentr DATETIME NOT NULL,
    descr VARCHAR(255) NOT NULL,
    emissor VARCHAR(100) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    assunto VARCHAR(255) NOT NULL,
    tipodoc VARCHAR(50) NOT NULL,
    nat VARCHAR(20) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    obs LONGTEXT,
    usuario VARCHAR(100),
    pastaarquiv VARCHAR(100),
    cpf VARCHAR(14),
    masp VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nrprotoc (nrprotoc),
    INDEX idx_dtentr (dtentr),
    INDEX idx_destino (destino),
    INDEX idx_nome (nome),
    INDEX idx_assunto (assunto),
    INDEX idx_emissor (emissor),
    INDEX idx_tipodoc (tipodoc),
    INDEX idx_nat (nat)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: tramitacao
-- NOVA: Não existia como tabela separada no legado SAdm
-- Foi extraída das regras de negócio do ASP
-- ============================================================
CREATE TABLE IF NOT EXISTS tramitacao (
    codmov VARCHAR(30) PRIMARY KEY,
    nrprotoc VARCHAR(30) NOT NULL,
    dtmovim DATETIME NOT NULL,
    orignome VARCHAR(100),
    destnome VARCHAR(100) NOT NULL,
    obs TEXT,
    prazo VARCHAR(50),
    emissor VARCHAR(100),
    assunto VARCHAR(255),
    tipodoc VARCHAR(50),
    descr TEXT,
    nome VARCHAR(255),
    dtentr DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tram_nrprotoc (nrprotoc),
    INDEX idx_tram_dtmovim (dtmovim),
    INDEX idx_tram_destnome (destnome),
    CONSTRAINT fk_tram_cadastro FOREIGN KEY (nrprotoc) REFERENCES cadastro(nrprotoc) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: moviment
-- Mapeamento da tabela legada "Moviment"
-- CodMov mudou de INTEGER AUTO_INCREMENT para VARCHAR
-- ============================================================
CREATE TABLE IF NOT EXISTS moviment (
    codmov VARCHAR(30) PRIMARY KEY,
    nrprotoc VARCHAR(30) NOT NULL,
    dtmovim DATETIME NOT NULL,
    orignome VARCHAR(100),
    destnome VARCHAR(100),
    obs TEXT,
    prazo VARCHAR(50),
    usua_mov VARCHAR(100),
    cumprido VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_mov_nrprotoc (nrprotoc),
    INDEX idx_mov_dtmovim (dtmovim),
    CONSTRAINT fk_mov_cadastro FOREIGN KEY (nrprotoc) REFERENCES cadastro(nrprotoc) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: orgaos
-- Mapeamento da tabela legada "Orgaos" (unidades organizacionais)
-- ============================================================
CREATE TABLE IF NOT EXISTS orgaos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orgao VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_orgao (orgao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: tipodoc
-- Mapeamento da tabela legada "Tipodoc" (tipos de documento)
-- ============================================================
CREATE TABLE IF NOT EXISTS tipodoc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipodoc VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tipodoc (tipodoc)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: acesso (log de acesso)
-- Mapeamento da tabela legada "acesso"
-- ============================================================
CREATE TABLE IF NOT EXISTS acesso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nr_usuario VARCHAR(20),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    acao VARCHAR(100),
    modulo VARCHAR(20),
    ip VARCHAR(45),
    INDEX idx_aces_nr_usuario (nr_usuario),
    INDEX idx_aces_data (data_hora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Tabela: sessoes (controle de sessão)
-- NOVA: Para gerenciamento de sessão em Go
-- ============================================================
CREATE TABLE IF NOT EXISTS sessoes (
    id VARCHAR(64) PRIMARY KEY,
    nr_usuario VARCHAR(20) NOT NULL,
    nivel_acesso ENUM('admin', 'user', 'guest') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    INDEX idx_sess_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Admin padrão (senha: admin123)
-- ============================================================
INSERT INTO usuarios (nr_usuario, pg, nome, unidade, secao, senha, privilegio) VALUES
('1088608', 'ADM', 'Administrador', 'CGDOC', 'SADM', '$2a$10$dummyhash', 'adm')
ON DUPLICATE KEY UPDATE nome = nome;
