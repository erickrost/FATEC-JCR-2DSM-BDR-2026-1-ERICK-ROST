CREATE OR REPLACE PROCEDURE inserir_livro(
p_titulo VARCHAR, p_ano INTEGER, p_autor INTEGER, p_editora INTEGER, p_paginas INTEGER)
LANGUAGE plpgsql AS $$ BEGIN IF NOT EXISTS (
SELECT 1 FROM autor WHERE id_autor = p_autor) 
THEN RAISE EXCEPTION 'Autor não encontrado';
END IF;

INSERT INTO livro(titulo,ano_publicacao,id_autor,id_editora,num_paginas)
VALUES (p_titulo,p_ano,p_autor,p_editora,p_paginas); 
END; $$;

CALL inserir_livro('Teste',2025,1,1,100);

CALL inserir_livro('Teste',2025,99,1,100);

CREATE OR REPLACE PROCEDURE atualizar_paginas(p_id_livro INTEGER, p_paginas INTEGER) LANGUAGE plpgsql AS $$ BEGIN
IF p_paginas <= 10 THEN RAISE EXCEPTION 'Número de páginas deve ser maior que 10';
END IF;

UPDATE livro SET num_paginas = p_paginas WHERE id_livro = p_id_livro;

END; $$;

CALL atualizar_paginas(1,300);
CALL atualizar_paginas(1,3);

SELECT * FROM livro WHERE id_livro = 1;
CALL atualizar_paginas(1,5);

CREATE OR REPLACE PROCEDURE excluir_autor(
p_id_autor INTEGER)
LANGUAGE plpgsql AS $$ BEGIN

IF EXISTS (
SELECT 1 FROM livro
WHERE id_autor = p_id_autor)
THEN
RAISE EXCEPTION 'Autor possui livros cadastrados';
END IF;

DELETE FROM autor
WHERE id_autor = p_id_autor;

END; $$;

CALL excluir_autor(1);

INSERT INTO autor VALUES (6,'Autor Teste');

CALL excluir_autor(6);

CREATE OR REPLACE PROCEDURE media_paginas_autor(
p_id_autor INTEGER)
LANGUAGE plpgsql AS $$ BEGIN

RAISE NOTICE '%',
(SELECT a.nome || ' - Média de páginas: ' || AVG(l.num_paginas)
FROM autor a JOIN livro l ON a.id_autor = l.id_autor
WHERE a.id_autor = p_id_autor
GROUP BY a.nome);

END; $$;

CALL media_paginas_autor(1);
------

CREATE OR REPLACE PROCEDURE inserir_livro_validado(p_titulo VARCHAR, p_ano INTEGER, p_autor INTEGER, p_editora INTEGER, p_paginas INTEGER)
LANGUAGE plpgsql AS $$ BEGIN

IF p_paginas <= 0 THEN RAISE EXCEPTION 'Número de páginas deve ser maior que zero';
END IF;

IF p_titulo IS NULL OR p_titulo = '' THEN RAISE EXCEPTION 'Título não pode ser vazio';
END IF;

IF NOT EXISTS (SELECT 1 FROM autor WHERE id_autor = p_autor)
THEN RAISE EXCEPTION 'Autor não encontrado';
END IF;

INSERT INTO livro(titulo,ano_publicacao,id_autor,id_editora,num_paginas)
VALUES (p_titulo,p_ano,p_autor,p_editora,p_paginas);

END; $$;

CALL inserir_livro_validado('Livro Teste',2025,1,1,100);

CALL inserir_livro_validado('Livro Teste',2025,1,1,-10);

CALL inserir_livro_validado('',2025,1,1,100);

CALL inserir_livro_validado('Livro Teste',2025,99,1,100);

CALL inserir_livro_validado('Livro Inválido',2025,1,1,-50);