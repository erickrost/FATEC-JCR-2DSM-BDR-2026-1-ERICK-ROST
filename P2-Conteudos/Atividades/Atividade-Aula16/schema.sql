ALTER TABLE livro
ADD COLUMN quantidade INTEGER;

UPDATE livro SET quantidade = 5 WHERE id_livro = 1;
UPDATE livro SET quantidade = 3 WHERE id_livro = 2;
UPDATE livro SET quantidade = 0 WHERE id_livro = 3;
UPDATE livro SET quantidade = 8 WHERE id_livro = 4;
UPDATE livro SET quantidade = 0 WHERE id_livro = 5;
UPDATE livro SET quantidade = 2 WHERE id_livro = 6;
UPDATE livro SET quantidade = 1 WHERE id_livro = 7;
UPDATE livro SET quantidade = 0 WHERE id_livro = 8;
UPDATE livro SET quantidade = 4 WHERE id_livro = 9;
UPDATE livro SET quantidade = 0 WHERE id_livro = 10;
UPDATE livro SET quantidade = 3 WHERE id_livro = 11;
UPDATE livro SET quantidade = 2 WHERE id_livro = 12;
UPDATE livro SET quantidade = 1 WHERE id_livro = 13;
UPDATE livro SET quantidade = 0 WHERE id_livro = 14;

SELECT id_livro, titulo, quantidade 
FROM livro;

--1 

CREATE OR REPLACE FUNCTION bloquear_exclusao()
RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN

IF OLD.quantidade > 0 THEN
RAISE EXCEPTION 'Não é possível excluir livro com exemplares disponíveis';
END IF;

RETURN OLD;

END; $$;

CREATE TRIGGER trg_bloquear_exclusao
BEFORE DELETE ON livro
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao();

DELETE FROM livro WHERE id_livro = 1;

DELETE FROM livro WHERE id_livro = 14;

-- 2
CREATE TABLE log_livro(id_log SERIAL PRIMARY KEY,
titulo VARCHAR(255),
data_exclusao TIMESTAMP,
mensagem VARCHAR(255)
);

CREATE OR REPLACE FUNCTION log_exclusao_livro()
RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN

INSERT INTO log_livro(titulo,data_exclusao,mensagem)
VALUES (OLD.titulo, NOW(), 'Livro removido do sistema');

RETURN OLD;

END; $$;

CREATE TRIGGER trg_log_exclusao
AFTER DELETE ON livro
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_livro();

DELETE FROM livro WHERE id_livro = 15;

SELECT * FROM log_livro;

-- 3

CREATE OR REPLACE FUNCTION validar_limite_estoque()
RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN

IF NEW.quantidade > 100 THEN RAISE EXCEPTION 'Quantidade não pode ser maior que 100';
END IF;

RETURN NEW;

END; $$;

CREATE TRIGGER trg_validar_limite
BEFORE UPDATE ON livro
FOR EACH ROW
EXECUTE FUNCTION validar_limite_estoque();

UPDATE livro
SET quantidade = 50
WHERE id_livro = 1;

UPDATE livro
SET quantidade = 150
WHERE id_livro = 1;