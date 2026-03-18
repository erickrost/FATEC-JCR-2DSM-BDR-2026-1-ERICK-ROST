SELECT COUNT(*) AS total_usuarios
FROM Usuario;

SELECT idTipoEvento, COUNT(*) AS total_eventos
FROM Evento
GROUP BY idTipoEvento;

SELECT MIN(dataHora) AS evento_mais_antigo, MAX(dataHora) AS evento_mais_recente
FROM Evento;

SELECT AVG(total_eventos) AS media_eventos_por_cidade
FROM (
    SELECT l.cidade, COUNT(e.idEvento) AS total_eventos
    FROM Evento e
    JOIN Localizacao l ON e.idLocalizacao = l.idLocalizacao
    GROUP BY l.cidade
) sub;