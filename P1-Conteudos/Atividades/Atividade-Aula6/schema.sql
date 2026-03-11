DROP TABLE IF EXISTS HistoricoEvento, Alerta, Relato, Evento, Usuario, Localizacao, TipoEvento CASCADE;

CREATE TABLE TipoEvento (
    idTipoEvento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE Localizacao (
    idLocalizacao SERIAL PRIMARY KEY,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senhaHash VARCHAR(255) NOT NULL
);

CREATE TABLE Evento (
    idEvento SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    dataHora TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    idTipoEvento INTEGER NOT NULL,
    idLocalizacao INTEGER NOT NULL,
    FOREIGN KEY (idTipoEvento) REFERENCES TipoEvento(idTipoEvento),
    FOREIGN KEY (idLocalizacao) REFERENCES Localizacao(idLocalizacao)
);

CREATE TABLE Relato (
    idRelato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    dataHora TIMESTAMP NOT NULL,
    idEvento INTEGER NOT NULL,
    idUsuario INTEGER NOT NULL,
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Alerta (
    idAlerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    dataHora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    idEvento INTEGER NOT NULL,
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento)
);

CREATE TABLE HistoricoEvento (
    idHistorico SERIAL PRIMARY KEY,
    idEvento INTEGER NOT NULL,
    statusAnterior VARCHAR(50),
    statusNovo VARCHAR(50) NOT NULL,
    dataAlteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento)
);

INSERT INTO TipoEvento (nome, descricao) VALUES
('Queimada', 'Incêndio de grandes proporções em áreas urbanas ou rurais.'),
('Enchente', 'Transbordamento de rios ou alagamento por excesso de chuva.'),
('Deslizamento', 'Movimentação de terra em encostas.');

INSERT INTO Localizacao (latitude, longitude, cidade, estado) VALUES
(-23.305000, -45.965000, 'Jacareí', 'SP'),
(-23.223701, -45.900907, 'São José dos Campos', 'SP'),
(-22.903500, -43.209600, 'Rio de Janeiro', 'RJ');

INSERT INTO Usuario (nome, email, senhaHash) VALUES
('Maria Oliveira', 'maria@email.com', 'hash001'),
('João Silva', 'joao@email.com', 'hash002'),
('Ana Souza', 'ana@email.com', 'hash003');

INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) VALUES
('Queimada em área de preservação', 'Fogo na mata próxima à represa.', '2025-08-15 14:35:00', 'Ativo', 1, 1),
('Enchente no centro', 'Ruas alagadas após chuva intensa.', '2025-09-10 18:00:00', 'Em Monitoramento', 2, 2),
('Deslizamento em encosta', 'Queda de barreira após chuvas contínuas.', '2025-09-12 09:30:00', 'Resolvido', 3, 1);

INSERT INTO Relato (texto, dataHora, idEvento, idUsuario) VALUES
('Fumaça intensa visível da rodovia.', '2025-08-15 15:10:00', 1, 1),
('Água invadindo estabelecimentos.', '2025-09-10 18:30:00', 2, 2),
('Barreira bloqueando estrada local.', '2025-09-12 10:00:00', 3, 3);

INSERT INTO Alerta (mensagem, dataHora, nivel, idEvento) VALUES
('Evacuação imediata da área próxima.', '2025-08-15 15:20:00', 'Crítico', 1),
('Evitar deslocamentos na região central.', '2025-09-10 19:00:00', 'Alto', 2),
('Equipe da defesa civil acionada.', '2025-09-12 10:30:00', 'Médio', 3);

INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) VALUES
('Queimada em área rural', 'Fogo iniciado próximo a plantação.', '2025-10-01 16:20:00', 'Ativo', 1, 1),
('Alagamento em avenida principal', 'Chuva forte causou alagamento.', '2025-10-02 08:15:00', 'Em Monitoramento', 2, 2);

SELECT * FROM Usuario;
SELECT * FROM Evento;

SELECT titulo, status
FROM Evento
WHERE status = 'Ativo';

SELECT cidade, estado
FROM Localizacao
WHERE estado = 'SP';

SELECT titulo, dataHora, status
FROM Evento
ORDER BY dataHora DESC;

SELECT titulo, dataHora, status
FROM Evento
ORDER BY dataHora DESC
LIMIT 3;