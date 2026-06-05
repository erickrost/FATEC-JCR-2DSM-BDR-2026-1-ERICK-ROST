CREATE VIEW vw_livros_paginas AS
SELECT
    titulo,
    num_paginas
FROM livro;

SELECT *
FROM vw_livros_paginas;

CREATE VIEW vw_autores_mais_de_um_livro AS
SELECT
    a.nome,
    COUNT(*) AS total_livros
FROM autor a
JOIN livro l ON a.id_autor = l.id_autor
GROUP BY a.nome
HAVING COUNT(*) > 1;

SELECT *
FROM vw_autores_mais_de_um_livro;

CREATE VIEW vw_livros_acima_media_paginas AS
SELECT
    titulo,
    num_paginas
FROM livro
WHERE num_paginas > (
    SELECT AVG(num_paginas)
    FROM livro
);

SELECT *
FROM vw_livros_acima_media_paginas;

CREATE VIEW vw_autor_livro_ano AS
SELECT
    a.nome AS autor,
    l.titulo,
    l.ano_publicacao
FROM autor a
JOIN livro l
    ON a.id_autor = l.id_autor;

SELECT * FROM vw_autor_livro_ano;

CREATE VIEW vw_resumo_autores AS
SELECT
    a.nome AS autor,
    COUNT(l.id_livro) AS total_livros,
    MAX(l.num_paginas) AS maior_numero_paginas
FROM autor a
JOIN livro l
    ON a.id_autor = l.id_autor
GROUP BY a.nome;

SELECT * FROM vw_resumo_autores;