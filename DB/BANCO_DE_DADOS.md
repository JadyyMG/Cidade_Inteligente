# 📦 Documentação do Banco de Dados
## Sistema: Cidade Inteligente
### Plataforma Backend: Spring Boot + JPA/Hibernate

---

## 1. Visão Geral

O banco de dados suporta um sistema de denúncias urbanas com comunicação entre moradores, prefeitura e empresas de serviço. Recomenda-se **PostgreSQL** ou **MySQL** para produção.

---

## 2. Diagrama de Entidades

```
USUARIOS
    │
    ├──< DENUNCIAS (1 usuário → N denúncias)
    │         │
    │         └──< COMENTARIOS (1 denúncia → N comentários)
    │
    ├──< CHATS (1 usuário → N chats)
    │         │
    │         └──< MENSAGENS (1 chat → N mensagens)
    │
    └──< NOTIFICACOES (1 usuário → N notificações)

AREAS_BAIRROS
    │
    └──< USUARIO_AREAS (N:N entre usuários e bairros)

CATEGORIAS ──< DENUNCIAS
ORGAOS     ──< CHATS
```

---

## 3. Tabelas

---

### 3.1 `usuarios`
Armazena todos os usuários do sistema (moradores e funcionários).

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador único |
| `nome` | VARCHAR(150) | ✅ | Nome completo |
| `email` | VARCHAR(200) | ✅ | Email único de login |
| `senha_hash` | VARCHAR(255) | ✅ | Senha criptografada (BCrypt) |
| `telefone` | VARCHAR(20) | ❌ | Telefone / WhatsApp |
| `role` | ENUM | ✅ | `MORADOR`, `FUNCIONARIO`, `ADMIN` |
| `bairro_principal` | VARCHAR(100) | ❌ | Bairro de residência |
| `cidade` | VARCHAR(100) | ✅ | Cidade do usuário |
| `ativo` | BOOLEAN | ✅ | Se a conta está ativa (default: true) |
| `criado_em` | TIMESTAMP | ✅ | Data de cadastro (default: now) |

**Regras:**
- `email` deve ser único
- `senha_hash` nunca armazena senha em texto puro
- `role` define o nível de acesso no sistema

---

### 3.2 `categorias`
Categorias de denúncias (tabela de referência).

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | INT (PK, AUTO) | ✅ | Identificador |
| `nome` | VARCHAR(100) | ✅ | Ex: "Iluminação", "Buraco" |
| `emoji` | VARCHAR(10) | ❌ | Emoji representativo |
| `descricao` | VARCHAR(255) | ❌ | Descrição da categoria |

**Dados iniciais (seed):**
```sql
INSERT INTO categorias (nome, emoji) VALUES
('Iluminação', '💡'),
('Buraco / Pavimento', '🕳️'),
('Lixo / Entulho', '🗑️'),
('Água / Abastecimento', '💧'),
('Esgoto', '🚿'),
('Trânsito / Sinalização', '🚦'),
('Segurança', '🔒'),
('Outro', '📋');
```

---

### 3.3 `denuncias`
Tabela principal com as denúncias registradas pelos moradores.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador / protocolo |
| `usuario_id` | BIGINT (FK) | ✅ | Quem criou a denúncia |
| `categoria_id` | INT (FK) | ✅ | Categoria da denúncia |
| `titulo` | VARCHAR(200) | ✅ | Título resumido |
| `descricao` | TEXT | ✅ | Descrição detalhada |
| `status` | ENUM | ✅ | `ABERTA`, `EM_ANDAMENTO`, `RESOLVIDA`, `CANCELADA` |
| `visibilidade` | ENUM | ✅ | `PUBLICA`, `PRIVADA` |
| `bairro` | VARCHAR(100) | ✅ | Bairro do problema |
| `endereco` | VARCHAR(255) | ✅ | Endereço / referência |
| `latitude` | DECIMAL(10,8) | ❌ | Coordenada GPS |
| `longitude` | DECIMAL(11,8) | ❌ | Coordenada GPS |
| `curtidas` | INT | ✅ | Contador de apoios (default: 0) |
| `observacao_funcionario` | TEXT | ❌ | Resposta do responsável |
| `funcionario_id` | BIGINT (FK) | ❌ | Funcionário que atualizou |
| `criada_em` | TIMESTAMP | ✅ | Data de criação |
| `atualizada_em` | TIMESTAMP | ❌ | Última atualização |

**Relacionamentos:**
- `usuario_id` → `usuarios.id`
- `categoria_id` → `categorias.id`
- `funcionario_id` → `usuarios.id`

---

### 3.4 `fotos_denuncia`
Fotos anexadas a uma denúncia (separado para suportar múltiplas fotos).

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `denuncia_id` | BIGINT (FK) | ✅ | Denúncia relacionada |
| `url` | VARCHAR(500) | ✅ | URL da imagem (S3, Firebase, etc.) |
| `ordem` | INT | ✅ | Ordem de exibição (default: 0) |
| `criada_em` | TIMESTAMP | ✅ | Data do upload |

---

### 3.5 `comentarios`
Comentários públicos em denúncias.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `denuncia_id` | BIGINT (FK) | ✅ | Denúncia comentada |
| `usuario_id` | BIGINT (FK) | ✅ | Autor do comentário |
| `texto` | TEXT | ✅ | Conteúdo do comentário |
| `criado_em` | TIMESTAMP | ✅ | Data do comentário |

---

### 3.6 `orgaos`
Órgãos e empresas disponíveis para chat (Prefeitura, CELPE, COMPESA, etc.).

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | INT (PK, AUTO) | ✅ | Identificador |
| `nome` | VARCHAR(150) | ✅ | Ex: "Prefeitura de Caruaru" |
| `subtitulo` | VARCHAR(150) | ❌ | Ex: "Suporte Geral" |
| `emoji` | VARCHAR(10) | ❌ | Ícone representativo |
| `ativo` | BOOLEAN | ✅ | Se está disponível para contato |

**Dados iniciais (seed):**
```sql
INSERT INTO orgaos (nome, subtitulo, emoji) VALUES
('Prefeitura de Caruaru', 'Suporte Geral', '🏛️'),
('COMPESA', 'Água e Saneamento', '💧'),
('CELPE', 'Energia Elétrica', '⚡'),
('EMLUR', 'Limpeza Urbana', '🗑️');
```

---

### 3.7 `chats`
Conversas entre usuários e órgãos.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `usuario_id` | BIGINT (FK) | ✅ | Morador participante |
| `orgao_id` | INT (FK) | ✅ | Órgão participante |
| `status` | ENUM | ✅ | `ABERTO`, `FECHADO` |
| `criado_em` | TIMESTAMP | ✅ | Data de abertura |
| `atualizado_em` | TIMESTAMP | ✅ | Última mensagem |

---

### 3.8 `mensagens`
Mensagens trocadas em um chat.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `chat_id` | BIGINT (FK) | ✅ | Chat ao qual pertence |
| `autor_id` | BIGINT (FK) | ✅ | Usuário que enviou |
| `texto` | TEXT | ✅ | Conteúdo da mensagem |
| `lida` | BOOLEAN | ✅ | Se foi lida (default: false) |
| `enviada_em` | TIMESTAMP | ✅ | Data/hora do envio |

---

### 3.9 `notificacoes`
Notificações enviadas aos usuários.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `usuario_id` | BIGINT (FK) | ✅ | Destinatário |
| `titulo` | VARCHAR(200) | ✅ | Título da notificação |
| `corpo` | TEXT | ✅ | Conteúdo da mensagem |
| `tipo` | ENUM | ✅ | `DENUNCIA`, `EMERGENCIA`, `REFORMA`, `AVISO`, `RESOLUCAO` |
| `lida` | BOOLEAN | ✅ | Se foi lida (default: false) |
| `denuncia_id` | BIGINT (FK) | ❌ | Denúncia relacionada (se houver) |
| `criada_em` | TIMESTAMP | ✅ | Data de criação |

---

### 3.10 `bairros`
Bairros disponíveis no sistema.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | INT (PK, AUTO) | ✅ | Identificador |
| `nome` | VARCHAR(100) | ✅ | Nome do bairro |
| `cidade` | VARCHAR(100) | ✅ | Cidade |
| `emoji` | VARCHAR(10) | ❌ | Emoji representativo |

---

### 3.11 `usuario_bairros` *(tabela de junção N:N)*
Relaciona usuários com os bairros que acompanham.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `usuario_id` | BIGINT (FK) | ✅ | Usuário |
| `bairro_id` | INT (FK) | ✅ | Bairro acompanhado |

**PK composta:** (`usuario_id`, `bairro_id`)

---

### 3.12 `logs`
Registro de ações importantes no sistema para auditoria.

| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| `id` | BIGINT (PK, AUTO) | ✅ | Identificador |
| `usuario_id` | BIGINT (FK) | ❌ | Quem realizou a ação |
| `acao` | VARCHAR(255) | ✅ | Descrição da ação |
| `tabela_afetada` | VARCHAR(100) | ❌ | Ex: "denuncias" |
| `registro_id` | BIGINT | ❌ | ID do registro afetado |
| `criado_em` | TIMESTAMP | ✅ | Data/hora da ação |

---

## 4. Endpoints REST sugeridos para o Spring Boot

### Autenticação
| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/auth/login` | Login, retorna JWT |
| POST | `/auth/cadastro` | Cadastro de novo usuário |
| POST | `/auth/logout` | Invalida token |

### Denúncias
| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/denuncias` | Lista denúncias públicas (com filtros) |
| POST | `/denuncias` | Cria nova denúncia |
| GET | `/denuncias/{id}` | Detalhes de uma denúncia |
| PATCH | `/denuncias/{id}/status` | Atualiza status (funcionário) |
| GET | `/denuncias/minhas` | Denúncias do usuário logado |

### Chat
| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/chats` | Lista chats do usuário |
| POST | `/chats` | Abre novo chat com um órgão |
| GET | `/chats/{id}/mensagens` | Mensagens de um chat |
| POST | `/chats/{id}/mensagens` | Envia mensagem |

### Notificações
| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/notificacoes` | Lista notificações do usuário |
| PATCH | `/notificacoes/{id}/lida` | Marca como lida |
| PATCH | `/notificacoes/todas/lidas` | Marca todas como lidas |

### Usuário
| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/usuarios/perfil` | Dados do usuário logado |
| PUT | `/usuarios/perfil` | Atualiza perfil |
| GET | `/usuarios/bairros` | Bairros que o usuário acompanha |
| PUT | `/usuarios/bairros` | Atualiza bairros acompanhados |

---

## 5. Configuração Spring Boot (application.properties)

```properties
# PostgreSQL (recomendado para produção)
spring.datasource.url=jdbc:postgresql://localhost:5432/cidade_inteligente
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA / Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# JWT
jwt.secret=sua_chave_secreta_muito_longa_aqui
jwt.expiration=86400000

# Upload de arquivos
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

---

## 6. Dependências Maven (pom.xml)

```xml
<!-- Spring Web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- Spring Data JPA -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<!-- Spring Security + JWT -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>

<!-- PostgreSQL -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>

<!-- Lombok (reduz boilerplate) -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>

<!-- Validação -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

---

*Documentação gerada para o projeto Cidade Inteligente — Backend Spring Boot*
