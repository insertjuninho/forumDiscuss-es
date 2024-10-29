# Fórum de Discussões


### Este é um sistema básico de fórum de discussões com funcionalidades para gerenciamento de usuários, posts, grupos e comentários. O backend da aplicação foi desenvolvido com Node.js, Hono, tRPC, Kysely e PostgreSQL.

## Tecnologias Utilizadas

Node.js: Ambiente de execução para Javascript.

Hono: Framework leve e performático para desenvolvimento de APIs.

tRPC: Biblioteca para construção de APIs de forma segura e com tipagem.

Kysely: ORM para consultas em SQL de forma tipada.

PostgreSQL: Sistema de banco de dados relacional.

## Funcionalidades

Sistema de Autenticação: Gerenciamento de sessões e autenticação de usuários.

Gerenciamento de Usuários: Cadastro, atualização e remoção de usuários.

Postagens: Criação, edição e exclusão de posts de discussão.

Grupos: Organização de discussões em grupos.

Comentários: Adição de comentários em posts.



## Pré-requisitos
Docker instalado para gerenciar os containers.

Arquivo de variáveis de ambiente .env configurado conforme descrito abaixo.

Variáveis de Ambiente

Crie um arquivo .env na raiz do projeto e configure as seguintes variáveis:

```
DATABASE_URL=postgresql://user:password@localhost:5432/database_name

JWT_SECRET=seu_token_secreto_para_jwt

PORT=3000

Nota: Substitua os valores de acordo com a configuração do seu ambiente.
```
## Instruções para Execução
Certifique-se de que o Docker está instalado e em execução em sua máquina.

Com o arquivo .env configurado, execute o seguinte comando para inicializar a aplicação:

```
docker compose up
```
Após isso, o servidor estará disponível em http://localhost:3000.

## Estrutura de Rotas

```
Autenticação: POST /auth - Gerencia o fluxo de autenticação e criação de tokens.

Posts:

POST /posts - Criação de posts; 
GET /posts/:id - Consulta posts.

Usuários: GET /users/:id - Consulta de informações de usuários.

Grupos: POST /groups - Criação e consulta de grupos de discussão.
```
## Comandos Úteis
### Iniciar a aplicação:

```
Iniciar a aplicação:
    docker compose up
    
Encerrar a aplicação:
    docker compose down
```

## Banco de dados
DER do banco de dados.
```
https://dbdiagram.io/d/mediq-671fffd797a66db9a390dab6
```