-- ============================================================
-- Migration 002: Hash de senhas plain text para bcrypt
-- 
-- Este script cria uma funcao que atualiza senhas plain text
-- para bcrypt. Como MySQL/MariaDB nao tem bcrypt nativo,
-- as senhas serao hasheadas pela aplicacao no primeiro login
-- (implementado no auth service).
--
-- Aqui apenas marcamos quais usuarios tem senha plain text
-- para referencia.
-- ============================================================

-- Adiciona coluna para trackear status da senha
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS senha_hash VARCHAR(60) DEFAULT NULL AFTER senha;

-- Copia senha original se ainda estiver em plain text
UPDATE usuarios SET senha_hash = senha 
WHERE senha IS NOT NULL 
  AND LENGTH(senha) < 60;

-- Remove senhas que sao claramente placeholders
UPDATE usuarios SET senha = "" WHERE senha = "trocar_senha";

SELECT CONCAT("Senhas plain text marcadas: ", ROW_COUNT()) AS status;
