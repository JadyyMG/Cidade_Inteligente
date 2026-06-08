CREATE TABLE usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    role ENUM('MORADOR', 'FUNCIONARIO', 'ADMIN') NOT NULL DEFAULT 'MORADOR',
    bairro_principal VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    emoji VARCHAR(10),
    descricao VARCHAR(255)
);

CREATE TABLE orgaos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    subtitulo VARCHAR(150),
    emoji VARCHAR(10),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE bairros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    emoji VARCHAR(10)
);

CREATE TABLE denuncias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    categoria_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL,
    status ENUM('ABERTA', 'EM_ANDAMENTO', 'RESOLVIDA', 'CANCELADA') NOT NULL DEFAULT 'ABERTA',
    visibilidade ENUM('PUBLICA', 'PRIVADA') NOT NULL DEFAULT 'PUBLICA',
    bairro VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    curtidas INT NOT NULL DEFAULT 0,
    observacao_funcionario TEXT,
    funcionario_id BIGINT,
    criada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizada_em TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (funcionario_id) REFERENCES usuarios(id)
);

CREATE TABLE fotos_denuncia (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    denuncia_id BIGINT NOT NULL,
    url VARCHAR(500) NOT NULL,
    ordem INT NOT NULL DEFAULT 0,
    criada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (denuncia_id) REFERENCES denuncias(id)
);

CREATE TABLE comentarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    denuncia_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    texto TEXT NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (denuncia_id) REFERENCES denuncias(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE chats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    orgao_id INT NOT NULL,
    status ENUM('ABERTO', 'FECHADO') NOT NULL DEFAULT 'ABERTO',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (orgao_id) REFERENCES orgaos(id)
);

CREATE TABLE mensagens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    chat_id BIGINT NOT NULL,
    autor_id BIGINT NOT NULL,
    texto TEXT NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    enviada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES chats(id),
    FOREIGN KEY (autor_id) REFERENCES usuarios(id)
);

CREATE TABLE notificacoes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    corpo TEXT NOT NULL,
    tipo ENUM('DENUNCIA', 'EMERGENCIA', 'REFORMA', 'AVISO', 'RESOLUCAO') NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    denuncia_id BIGINT,
    criada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (denuncia_id) REFERENCES denuncias(id)
);

CREATE TABLE usuario_bairros (
    usuario_id BIGINT NOT NULL,
    bairro_id INT NOT NULL,
    PRIMARY KEY (usuario_id, bairro_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (bairro_id) REFERENCES bairros(id)
);

