-- Criação dos 3 bancos de dados necessários para a tramitação entre módulos
CREATE DATABASE IF NOT EXISTS movedb_SAdm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS movedb_Sercod CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS movedb_Sercod_SAdm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Garantir que o usuário principal tenha acesso total aos três bancos
-- (Para permitir consultas cruzadas como UNION ALL)
GRANT ALL PRIVILEGES ON movedb_SAdm.* TO 'cgdoc_user'@'%';
GRANT ALL PRIVILEGES ON movedb_Sercod.* TO 'cgdoc_user'@'%';
GRANT ALL PRIVILEGES ON movedb_Sercod_SAdm.* TO 'cgdoc_user'@'%';
FLUSH PRIVILEGES;
