
--CRIAÇÃO DO USUÁRIO E DO BANCO DE DADOS

DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS jorge;
CREATE USER jorge WITH ENCRYPTED PASSWORD 'jorge159' LOGIN CREATEDB CREATEROLE;
CREATE DATABASE uvv
WITH OWNER = jorge
TEMPLATE = template0
ENCODING = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true;
COMMENT ON DATABASE uvv IS 'Database da loja da uvv';
\c "dbname = uvv user = jorge password = jorge159"

--CRIAÇÃO DO SCHMEA LOJAS E COMENTARIO DO SCHEMA LOJAS

CREATE SCHEMA lojas AUTHORIZATION jorge;
COMMENT ON SCHEMA lojas IS 'Schema do banco de dados da loja da uvv';

--ALTERAÇÃO DO PATH
 
SET SEARCH_PATH TO lojas, "$user", public;
ALTER USER jorge
SET SEARCH_PATH TO lojas, "$user", public;

--CRIAÇAO DA TABELA produtos

CREATE TABLE lojas.produtos (
                produto_id                NUMERIC(38)  NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2),
                detalhes                  BYTEA,
                imagem                    BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);

--COMENTÁRIOS DA TABELA produtos

COMMENT ON TABLE  lojas.produtos                           IS 'Tabela com dados dos produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'ID do produto.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço por unidade do produto.';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes do produto.';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'Imagem mime type do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Path do arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Imagem charset do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da última atualização feita na imagem.';

--CRIAÇAO DA TABELA lojas

CREATE TABLE lojas.lojas (
                loj_id                  NUMERIC(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loj_id)
);

--COMENTÁRIOS DA TABELA lojas

COMMENT ON TABLE  lojas.lojas                         IS 'Tabela com dados de cada loja cadastrada.';
COMMENT ON COLUMN lojas.lojas.loj_id                  IS 'ID da loja.';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Nome da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Endereço web da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Endereço físico da loja.';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Latitude da loja.';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Longitude da loja.';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'Logo mime type da loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Arquivo onde está a logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Logo charset da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da última atualização feita na logo.';

--CRIAÇAO DA TABELA estoques

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);

--COMENTÁRIOS DA TABELA estoques

COMMENT ON TABLE  lojas.estoques             IS 'Tabela com dados do estoque.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'ID do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'ID da loja.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'ID do produto.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade de produtos no estoque da loja.';

--CRIAÇAO DA TABELA clientes

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);

--COMENTÁRIOS DA TABELA clientes

COMMENT ON TABLE  lojas.clientes            IS 'Tabela com dados de todos os clientes cadastrados.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'ID do cliente.';
COMMENT ON COLUMN lojas.clientes.email      IS 'Email do cliente.';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Primeiro número de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Segundo número de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Terceiro número de telefone do cliente.';

--CRIAÇAO DA TABELA envios

CREATE TABLE lojas.envios (
                envio_id         NUMERIC(38)  NOT NULL,
                loja_id          NUMERIC(38)  NOT NULL,
                cliente_id       NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);

--COMENTÁRIOS DA TABELA envios

COMMENT ON TABLE  lojas.envios                  IS 'Tabela com dados dos envios.';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'ID do envio.';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'ID da loja.';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'ID do cliente.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço da entrega.';
COMMENT ON COLUMN lojas.envios.status           IS 'Status do envio.';

--CRIAÇAO DA TABELA pedidos

CREATE TABLE lojas.pedidos (
                pedido_id  NUMERIC(38) NOT NULL,
                data_hora  TIMESTAMP   NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status     VARCHAR(15) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);

--COMENTÁRIOS DA TABELA pedidos

COMMENT ON TABLE  lojas.pedidos            IS 'Tabela com todos os pedidos realizados.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'ID do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Data e horário da realização do pedido.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'ID do cliente';
COMMENT ON COLUMN lojas.pedidos.status     IS 'Status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'ID da loja.';

--CRIAÇAO DA TABELA pedidos_itens

CREATE TABLE lojas.pedidos_itens (
                pedido_id       NUMERIC(38)   NOT NULL,
                produto_id      NUMERIC(38)   NOT NULL,
                numero_da_linha NUMERIC(38)   NOT NULL,
                preco_unitario  NUMERIC(10,2) NOT NULL,
                quantidade      NUMERIC(38)   NOT NULL,
                envio_id        NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

--COMENTÁRIOS DA TABELA pedidos_itens

COMMENT ON TABLE  lojas.pedidos_itens                 IS 'Tabela com cada item de todos os pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'ID do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'ID do produto.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Número da linha.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'Preço por unidade.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'Quantidade de produto no pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'ID do envio.';


--CRIANÇÃO DOS RELACIONAMENTOS

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--CRIAÇÃO DAS RESTRIÇÕES DE CHECAGEM


--TABELA pedidos
ALTER TABLE pedidos
ADD CONSTRAINT constraint_pedidos_status CHECK(status IN ('CANCELADO','COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO'));


--TABELA envios
ALTER TABLE envios
ADD CONSTRAINT constraint_envios_status CHECK(status IN ('CRIADO','ENVIADO','TRANSITO','ENTREGUE'));


--TABELA lojas
ALTER TABLE lojas
ADD CONSTRAINT constraint_lojas_endereco_fisico CHECK(COALESCE(endereco_fisico, endereco_web) IS NOT NULL);


--TABEA produtos
ALTER TABLE produtos
ADD CONSTRAINT constraint_produtos_preco_unitario CHECK(preco_unitario > 0);


--TABELA pedidos_itens
ALTER TABLE pedidos_itens
ADD CONSTRAINT constraint_pedidos_itens_preco_unitario CHECK(preco_unitario > 0);
ALTER TABLE pedidos_itens
ADD CONSTRAINT constraint_pedidos_itens_quantidade CHECK(quantidade >= 0);


--TABELA estoques
ALTER TABLE estoques
ADD CONSTRAINT constraint_estoques_quantidades CHECK(quantidade >= 0);
