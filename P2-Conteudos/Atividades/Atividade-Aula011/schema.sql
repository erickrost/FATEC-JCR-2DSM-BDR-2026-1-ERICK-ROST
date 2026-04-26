--exercicio 1

SELECT a.nome,
(SELECT COUNT(*) FROM Livro l WHERE l.id_autor = a.id_autor) AS total_livros,
(SELECT AVG(num_paginas) FROM Livro l WHERE l.id_autor = a.id_autor) AS
media_paginas
FROM Autor a;
WITH ResumoLivros AS ( SELECT id_autor,
COUNT(*) AS total_livros, AVG(num_paginas) AS media_paginas
FROM Livro GROUP BY id_autor
)
SELECT a.nome,
COALESCE(r.total_livros, 0) AS total_livros,
COALESCE(r.media_paginas, 0) AS media_paginas
FROM Autor a LEFT JOIN ResumoLivros r ON a.id_autor = r.id_autor;


exercicio 2

WITH paginas_por_autor AS ( SELECT id_autor, SUM(num_paginas) AS soma_total
FROM Livro GROUP BY id_autor)
SELECT a.nome, p.soma_total
FROM Autor a JOIN paginas_por_autor p ON a.id_autor = p.id_autor
WHERE p.soma_total > (SELECT AVG(num_paginas) FROM Livro);


exercicio 3

SELECT a.nome,
(SELECT COUNT(*)
FROM Livro l WHERE l.id_autor = a.id_autor) AS total_livros FROM Autor a;
WITH contagem_cte AS (
SELECT id_autor, COUNT(*) AS total
FROM Livro
GROUP BY id_autor
)
SELECT a.nome,
COALESCE(c.total, 0) AS total_livros
FROM Autor a LEFT JOIN contagem_cte c ON a.id_autor = c.id_autor;