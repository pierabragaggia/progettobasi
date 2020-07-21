Drop table if exists Educatore;
Drop table if exists Iscritti;
Drop table if exists RegistroAttività;
Drop table if exists Attività;
Drop table if exists ImpieghiAttuali;
Drop table if exists RegistroImpieghi;
Drop table if exists Turno;
Drop table if exists Lavoro;
Drop table if exists AziendaAppaltata;
Drop table if exists Amministrativo;
Drop table if exists RegistroTurniGuardie;
Drop table if exists ContoCorrente;
Drop table if exists Processo;
Drop table if exists Avvocato;
Drop table if exists Studio;
Drop table if exists Detenuto;
Drop table if exists Stanza;
Drop table if exists Reparto;
Drop table if exists Guardia;
DROP FUNCTION IF EXISTS ContaMassimo;
DROP FUNCTION IF EXISTS DataRilascio;
DROP TRIGGER IF EXISTS RegistraLavoro;
DROP TRIGGER IF EXISTS AssegnaStanza;
DROP PROCEDURE IF EXISTS AccreditoCC;
DROP VIEW IF EXISTS LavoriFuori;
DROP VIEW IF EXISTS DetBlocco1;
DROP VIEW IF EXISTS RespAttività;
DROP VIEW IF EXISTS NumIscritti;
DROP VIEW IF EXISTS RicchezzaBlocco;

/*Crea la tabella per Guardia*/
CREATE TABLE Guardia(
	ID_Guardia INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Cognome VARCHAR(25) NOT NULL,	
	DataN DATE,
	Stipendio INT(4),
	Specialità VARCHAR(25),
	DataR DATE
);


/*Crea la tabella per Reparto*/
CREATE TABLE Reparto (
	CodR INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Tipo ENUM ('blocco','zonaC') NOT NULL,
	Responsabile INT(4),
	FOREIGN KEY (Responsabile) REFERENCES Guardia(ID_Guardia) 
ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per Stanza*/
CREATE TABLE Stanza (
	Numero INT(4) PRIMARY KEY NOT NULL,
	Blocco INT(4),
	Posti INT(3) NOT NULL,
FOREIGN KEY (Blocco) REFERENCES Reparto(CodR) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per Detenuto*/
CREATE TABLE Detenuto(
	Mat INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Cognome VARCHAR(25) NOT NULL,
	DataN DATE NOT NULL,
	Naz VARCHAR(25),
	Numero INT(4), 
	FOREIGN KEY (Numero) REFERENCES Stanza(Numero) ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per Studio*/
CREATE TABLE Studio(
	CodS INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Città VARCHAR(25) NOT NULL,
	Indirizzo VARCHAR(25) NOT NULL,
	Recapito VARCHAR(25)
);


/*Crea la tabella per Avvocato*/
CREATE TABLE Avvocato(
	CodA INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Cognome VARCHAR(25) NOT NULL,
	CodS INT(4),
	FOREIGN KEY (CodS) REFERENCES Studio(CodS) ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per Processo*/
CREATE TABLE Processo(
	Mat INT(4) NOT NULL,
	DataP DATE NOT NULL,
	Reato VARCHAR(1501),
	CodA INT(4) , 
	Durata INT(4),
	DataI DATE,
	Città VARCHAR(25),
	PRIMARY KEY(Mat, DataP),
	FOREIGN KEY (Mat) REFERENCES Detenuto(Mat) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (CodA) REFERENCES Avvocato(CodA) ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per ContoCorrente*/
CREATE TABLE ContoCorrente(
	CC INT(4) NOT NULL,
	Saldo INT(4),
	Mat INT(4) NOT NULL,
	PRIMARY KEY (CC, Mat),
	FOREIGN KEY (Mat) REFERENCES Detenuto(Mat) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per RegistroTurniGuardie*/
CREATE TABLE RegistroTurniGuardie (
	ID_Guardia INT(4) NOT NULL,
	Data DATE NOT NULL,
	Reparto INT(4),
	OraI TIME,
	OraF TIME,
	PRIMARY KEY (ID_Guardia, Data, Reparto),
FOREIGN KEY (Reparto) REFERENCES Reparto(CodR) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (ID_Guardia) REFERENCES Guardia(ID_GUARDIA) 
ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per Amministrativo*/
CREATE TABLE Amministrativo (
	ID_Amm INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
Cognome VARCHAR(25) NOT NULL,
DataN DATE,
Stipendio INT(4),
Ruolo VARCHAR(25)
);


/*Crea la tabella per AziendaAppaltata*/
CREATE TABLE AziendaAppaltata(
	pIVA VARCHAR(11) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Recapito VARCHAR(25),
	Indirizzo VARCHAR(50)
);


/*Crea la tabella per Lavoro*/
CREATE TABLE Lavoro(
	CodL INT(4) PRIMARY KEY NOT NULL,
	Descrizione VARCHAR(60),
	RetrOraria INT(4) NOT NULL,
	Max INT(4) NOT NULL,
	Tipo ENUM ('interno','esterno'),
	pIVA VARCHAR(11),
	Responsabile INT(4),
	FOREIGN KEY (pIVA) REFERENCES AziendaAppaltata(pIVA) 
ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Responsabile) REFERENCES Amministrativo(ID_Amm) 
ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per Turno*/
CREATE TABLE Turno(
	Data DATE NOT NULL,
	Codice INT(4) NOT NULL,
	OraI TIME NOT NULL,
	OraF TIME NOT NULL,
	PRIMARY KEY (Data, Codice, OraI),
	FOREIGN KEY (Codice) REFERENCES Lavoro(CodL) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per RegistroImpieghi*/
CREATE TABLE RegistroImpieghi(
	Det INT(4) NOT NULL,
	Lavoro INT(4) NOT NULL,
	DataI DATE NOT NULL,
	DataF DATE NOT NULL,
	PRIMARY KEY (Det, DataI),
FOREIGN KEY (Det) REFERENCES Detenuto(Mat) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Lavoro) REFERENCES Lavoro(CodL) ON DELETE NO ACTION ON UPDATE CASCADE
);


/*Crea la tabella per ImpieghiAttuali*/
CREATE TABLE ImpieghiAttuali(
	Det INT(4) PRIMARY KEY NOT NULL,
	Lavoro INT(4) NOT NULL,
	DataI DATE NOT NULL,
	FOREIGN KEY (Det) REFERENCES Detenuto(Mat) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Lavoro) REFERENCES Lavoro(CodL) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per Attività*/
CREATE TABLE Attività (
	CodAtt INT(4)  PRIMARY KEY NOT NULL,
	Descrizione VARCHAR(150) NOT NULL,
	Max INT(4)
);


/*Crea la tabella per RegistroAttività*/
CREATE TABLE RegistroAttività (
	AttSvolta INT(4) NOT NULL, 
	Rep INT(4),
GiornoSett ENUM('lun','mar','mer','gio','ven','sab','dom') NOT NULL,
OraI TIME,
OraF TIME,
PRIMARY KEY(AttSvolta, GIornoSett, OraI),
	FOREIGN KEY (AttSvolta) REFERENCES Attività(CodAtt) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Rep) REFERENCES Reparto(CodR) ON DELETE SET NULL ON UPDATE CASCADE
);


/*Crea la tabella per Iscritti*/
CREATE TABLE Iscritti (
	Matricola INT(4) NOT NULL,
	Attività INT(4) NOT NULL,
	PRIMARY KEY (Matricola, Attività),
	FOREIGN KEY (Matricola) REFERENCES Detenuto(Mat) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Attività) REFERENCES Attività(CodAtt) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Crea la tabella per Educatore*/
CREATE TABLE Educatore(
	ID_Educatore INT(4) PRIMARY KEY NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Cognome VARCHAR(25) NOT NULL,
	DataN DATE,
	Stipendio INT(4),
	Laurea VARCHAR(25),
	Attività INT(4),
	pIVA VARCHAR(11),
	FOREIGN KEY (Attività) REFERENCES Attività(CodAtt) 
ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (pIVA) REFERENCES AziendaAppaltata(pIVA) 
ON DELETE CASCADE ON UPDATE CASCADE
);


/*Funzione di calcolo lavoro preferito in data*/
DELIMITER $$
CREATE FUNCTION ContaMassimo (Datalavoro DATE)
RETURNS VARCHAR(25)
BEGIN
DECLARE LavoroMassimo VARCHAR(25);

SELECT H.Descrizione
FROM 
(SELECT COUNT(D.Mat) as numL, L.Descrizione
FROM Detenuto D JOIN ImpieghiAttuali IA ON D.Mat = IA.Det JOIN Lavoro L ON IA.Lavoro = L.CodL JOIN RegistroImpieghi RI ON L.CodL = RI.Lavoro
WHERE (RI.DataI <= Datalavoro AND RI.DataF >= Datalavoro) OR IA.DataI <= Datalavoro
GROUP BY L.Descrizione) H
ORDER BY H.numL DESC
LIMIT 1 INTO LavoroMassimo;

RETURN LavoroMassimo;

END
$$ 
DELIMITER ;


/*Funzione di calcolo della data di rilascio*/
DELIMITER $$
CREATE FUNCTION DataRilascio(Det INT(4))
RETURNS DATE
BEGIN
DECLARE DataF DATE;
DECLARE GiorniR INT(4);

SELECT DATE(DATE_ADD(P.DataI, interval P.Durata DAY))
FROM Detenuto D JOIN Processo P ON D.Mat = P.Mat
WHERE D.Mat = Det INTO DataF;

RETURN DataF;
END
$$
DELIMITER ;


/*Trigger per registrare i lavori passati*/
DELIMITER &&
CREATE TRIGGER RegistraLavoro BEFORE UPDATE ON ImpieghiAttuali
FOR EACH ROW
BEGIN

DECLARE DetImp INT;
DECLARE MaxImp INT;
DECLARE NewL INT;

SELECT COUNT(IA.Det)
FROM ImpieghiAttuali IA 
WHERE Lavoro = NEW.Lavoro INTO DetImp;

SELECT Max 
FROM Lavoro L
WHERE L.CodL = NEW.Lavoro INTO MaxImp;

IF(DetImp > MaxImp) THEN
SELECT MIN(L.CodL)
FROM Lavoro L LEFT JOIN (SELECT COUNT(Det) as Imp, Lavoro FROM ImpieghiAttuali GROUP BY Lavoro) IA ON L.CodL = IA.Lavoro 
WHERE L.Max > IA.Imp OR IA.Imp IS NULL INTO NewL;
SET NEW.Lavoro = NewL;
END IF;

INSERT INTO RegistroImpieghi(Det, Lavoro, DataI, DataF) VALUES
(NEW.Det, OLD.Lavoro, OLD.DataI, NEW.DataI);

END
&&
DELIMITER ;


/*Trigger per assegnare Stanza a nuovo detenuto*/
DROP TRIGGER IF EXISTS AssegnaStanza;
DELIMITER $$
CREATE TRIGGER AssegnaStanza BEFORE INSERT ON Detenuto
FOR EACH ROW
BEGIN
DECLARE stanzaAssegnata INT;

SELECT MIN(S1.Numero) as NumeroStanza
FROM Stanza S1 left join (SELECT COUNT(D.Mat) as Occupanti, D.Numero
FROM Detenuto D
GROUP BY D.Numero) SL on SL.Numero = S1.Numero
WHERE S1.Posti > SL.Occupanti or SL.Occupanti is null INTO stanzaAssegnata;

SET NEW.Numero = stanzaAssegnata;	

END 
$$
DELIMITER ;

/*Inserimento valori nella tabella Guardia*/
INSERT INTO Guardia (ID_Guardia, Nome, Cognome, DataN, Stipendio, Specialità, DataR) VALUES
('2001', 'Mario', 'Bianchi', '1958-02-17', '17000', 'Add. Det. Minorenni', '1985-06-12'),
('2002', 'Luigi', 'Rossi', '1974-11-03', '22000', 'Sommozzatore', '1985-06-12'),
('2003', 'Anna', 'Paoli', '1983-05-02', '35000', 'Servizio Cinofili', '2000-04-01'),
('2004', 'Silvia', 'Franceschini', '1982-10-04', '17000', 'Matricolista', '2000-04-01'),
('2005', 'Paolo', 'Lora', '1990-05-07', '18000', 'Telecomunicazioni', '2011-04-01'),
('2006', 'Giovanni', 'Rossato', '1982-04-10', '35000', 'Matricolista', '2000-04-01'),
('2007', 'Luca', 'Pichi', '1970-01-25', '22000', 'Elicotterista', '1985-06-12'),
('2008', 'Marica', 'Zaccari', '1989-07-12', '18000', 'Armaiolo', '2011-04-01'),
('2009', 'Damiano', 'Salvatore', '1967-04-11', '19000', 'Sommozzatore', '1985-06-12'),
('2010', 'Simone', 'Di Maggio', '1972-02-22', '17000', 'Armaiolo', '1994-08-23'),
('2011', 'Luisa', 'De Luca', '1985-09-28', '35000', 'Add. Det. Minorenni', '2000-04-01'),
('2012', 'Michela', 'Di Gregorio', '1992-01-31', '22000', 'Telecomunicazioni', '2011-04-01'),
('2013', 'Fabrizio', 'Marchi', '1989-10-20', '18000', 'Matricolista', '2008-04-01'),
('2014', 'Anna', 'Rossi', '1967-05-30', '19000', 'Telecomunicazioni', '1985-06-12'),
('2015', 'Michele', 'Giusti', '1989-02-28', '17000', 'Sommozzatore', '2008-04-01'),
('2016', 'Paolo', 'Brachetto', '1967-07-01', '35000', 'Armaiolo', '1985-06-12'),
('2017', 'Giuseppe', 'Sala', '1978-10-17', '22000', 'Add. Det. Minorenni', '2000-04-01'),
('2018', 'Claudia', 'Colosi', '1988-08-08', '18000', 'Armaiolo', '2008-04-01'),
('2019', 'Ettore', 'Edenti', '1989-09-09', '17000', 'Elicotterista', '2008-04-01'),
('2020', 'Simone', 'Zanetti', '1990-06-15', '22000', 'Sommozzatore', '2011-04-01');


/* Inserimento valori nella tabella reparto */
INSERT INTO Reparto(CodR, Nome, Tipo, Responsabile) VALUES  
('501', 'Blocco1', 'blocco', '2002'),
('502', 'Blocco2', 'blocco', '2003'),
('503', 'Blocco3', 'blocco', '2008'),
('504', 'Teatro', 'zonaC', '2001'),
('505', 'Aula Scolastica', 'zonaC', '2010'),
('506', 'Palestra', 'zonaC', '2011'),
('507', 'Officina', 'zonaC', '2014'),
('508', 'Mensa', 'zonaC', '2007'),
('509', 'Cucina', 'zonaC', '2005'),
('510', 'Campo sportivo', 'zonaC', '2006');


/*Inserimento valori nella tabella Stanza*/
INSERT INTO Stanza (Numero, Blocco, Posti) VALUES
('601', '501', '5'),
('602', '501', '5'),
('603', '502', '3'),
('604', '502', '3'),
('605', '502', '3'),
('606', '503', '2'),
('607', '503', '2'),
('608', '503', '3'),
('609', '501', '5'),
('610', '502', '4'),
('611', '501', '2'),
('612', '503', '5'),
('613', '503', '3'),
('614', '502', '3'),
('615', '502', '4'),
('616', '501', '2');


/*Inserimento valori nella tabella Detenuto*/
INSERT INTO Detenuto(Mat, Nome, Cognome, DataN, Naz, Numero) VALUES
('1001', 'Paolo', 'Rossi', '1988-05-17', 'Italiana', NULL),
('1002', 'Matteo', 'Russo', '1965-04-12', 'Italiana', NULL),
('1003', 'Luca', 'Ferrari', '1990-06-15', 'Italiana', NULL),
('1004', 'Giovanni', 'Bianchi', '1956-09-20', 'Italiana', NULL),
('1005', 'Tommaso', 'Romano', '1974-01-03', 'Italiana', NULL),
('1006', 'Pietro', 'Colombo', '1994-09-02', 'Italiana', NULL),
('1007', 'Leonardo', 'Ricci', '1987-12-06', 'Italiana', NULL),
('1008', 'Lorenzo', 'Marino', '1970-08-05', 'Italiana', NULL),
('1009', 'Fabio', 'Greco', '1982-08-07', 'Italiana', NULL),
('1010', 'Damiano', 'Bruno', '1991-07-30', 'Italiana', NULL),
('1011', 'Massimo', 'Esposito', '1973-03-03', 'Italiana', NULL),
('1012', 'Davide', 'Gallo', '1961-01-01', 'Italiana', NULL),
('1013', 'Enrico', 'De Luca', '1959-12-31', 'Italiana', NULL),
('1014', 'Andrea', 'Mancini', '1985-04-06', 'Italiana', NULL),
('1015', 'Adriano', 'Costa', '1966-09-23', 'Italiana', NULL),
('1016', 'Alberto', 'Giordano', '1980-08-02', 'Italiana', NULL),
('1017', 'Alessandro', 'Rizzo', '1959-08-31', 'Italiana', NULL),
('1018', 'Riccardo', 'Lombardi', '1982-10-10', 'Italiana', NULL),
('1019', 'Cesare', 'Moretti', '1948-11-11', 'Italiana', NULL),
('1020', 'Luigi', 'Barbieri', '1985-03-22', 'Italiana', NULL);


/*Inserimento valori nella tabella Studio*/
INSERT INTO Studio(CodS, Nome, Città, Indirizzo, Recapito) VALUES 
('4001', 'Studio Rossini', 'Padova', 'Via del Santo 8', '492788763'),
('4002', 'Fratelli Borga', 'Padova', 'Corso Milano 15', '498822773'),
('4003', 'Giuseppini e associati', 'Padova', 'Via delle Rose 1', '492345672'),
('4004', 'Paolini', 'Vicenza', 'Viale Trento 34', '444337788'),
('4005', 'Rossetto & co', 'Vicenza', 'Via dei Boschi 12', '444121212'),
('4006', 'Studio F.lli Minuti', 'Venezia', 'Corso Venezia 108', '418564745'),
('4007', 'Peripoveri', 'Venezia', 'Piazza Insurrezione 20', '419284676');


/*Inserimento valori nella tabella Avvocato*/
INSERT INTO Avvocato(CodA, Nome, Cognome, CodS) VALUES
('401', 'Emanuele', 'Borga', '4002'),
('402', 'Davide', 'Rossini', '4001'),
('403', 'Riccardo', 'Giuseppini', '4003'),
('404', 'Greta', 'Paolini', '4004'),
('405', 'Eleonora', 'Rossetto', '4005'),
('406', 'Marta', 'Minuti', '4006'),
('407', 'Nicola', 'Borga', '4002'),
('408', 'Luca', 'Farina', '4007'),
('409', 'Anna', 'Pagano', '4005'),
('410', 'Giacomo', 'Minuti', '4006'),
('411', 'Marco', 'Bellini', '4005'),
('412', 'Giovanni', 'Sartori', '4007');


/*Inserimento valori nella tabella Processo*/
INSERT INTO Processo(Mat, DataP, Reato, CodA, Durata, DataI, Città) VALUES
('1001', '2005-02-12', 'Omicidio colposo', '401', '5475', '2005-02-27', 'Padova'),
('1002', '2011-12-23', 'Truffa aggravata per il conseguimento di erogazioni pubbliche', '402', '6570', '2012-01-07', 'Venezia'),
('1003', '2011-06-03', 'Delitti informatici e trattamento illecito di dati', '403', '6570', '2011-06-18', 'Vicenza'),
('1004', '2010-06-13', 'Delitti di criminalità organizzata', '404', '5475', '2010-06-28', 'Padova'),
('1005', '2010-08-05', 'Illecita concorrenza con minaccia o violenza', '405', '7300', '2010-08-20', 'Venezia'),
('1006', '2010-07-02', 'Frode nell’esercizio del commercio', '406', '6570', '2010-07-17', 'Vicenza'),
('1007', '2014-01-11', 'Associazioni sovversive', '407', '7300', '2014-01-26', 'Venezia'),
('1008', '2013-02-13', 'Sequestro di persona a scopo di terrorismo o di eversione', '408', '5475', '2013-02-28', 'Venezia'),
('1009', '2014-01-03', 'Banda armata: formazione e partecipazione', '409', '7300', '2014-01-18', 'Padova'),
('1010', '2015-09-06', 'Ricettazione', '410', '6570', '2015-09-21', 'Vicenza'),
('1011', '2011-09-06', 'Delitti colposi contro l´ambiente', '411', '7300', '2011-09-21', 'Venezia'),
('1012', '2012-06-18', 'Attività di gestione di rifiuti non autorizzata', '412', '7300', '2012-07-03', 'Vicenza'),
('1013', '2015-09-06', 'Traffico illecito di rifiuti', '412', '7300', '2015-09-21', 'Padova'),
('1014', '2016-01-23', 'Associazione di tipo mafioso', '403', '5475', '2016-02-07', 'Venezia'),
('1015', '2011-06-03', 'Delitti informatici e trattamento illecito di dati', '405', '5475', '2011-06-18', 'Vicenza'),
('1016', '2010-01-03', 'Delitti informatici e trattamento illecito di dati', '407', '6570', '2010-01-18', 'Padova'),
('1017', '2011-07-08', 'Traffico illecito di rifiuti', '409', '7300', '2011-07-23', 'Venezia'),
('1018', '2014-12-10', 'Sequestro di persona a scopo di terrorismo o di eversione', '410', '5475', '2014-12-25', 'Venezia'),
('1019', '2014-03-29', 'Omicidio colposo', '411', '5475', '2014-04-13', 'Padova'),
('1020', '2015-12-13', 'Ricettazione', '401', '6570', '2015-12-28', 'Venezia');


/*Inserimento valori nella tabella ContoCorrente*/
INSERT INTO ContoCorrente(CC, Saldo, Mat) VALUES
('235', '100', '1001'),
('965', '150', '1002'),
('148', '50', '1003'),
('156', '200', '1004'),
('222', '100', '1005'),
('366', '50', '1006'),
('598', '150', '1007'),
('777', '300', '1008'),
('558', '150', '1009'),
('359', '50', '1010'),
('268', '100', '1011'),
('742', '150', '1012'),
('598', '250', '1013'),
('662', '200', '1014'),
('852', '50', '1015'),
('496', '50', '1016'),
('678', '100', '1017'),
('555', '60', '1018'),
('123', '150', '1019'),
('369', '100', '1020');


/*Inserimento valori nella tabella RegistroTurniGuardie*/
INSERT INTO RegistroTurniGuardie() VALUES
('2001', '2016-02-09', '501', '0:00', '8:00'),
('2002', '2016-02-09', '501', '8:00', '16:00'),
('2003', '2016-02-09', '501', '16:00', '0:00'),
('2004', '2016-02-09', '502', '0:00', '8:00'),
('2005', '2016-02-09', '502', '8:00', '16:00'),
('2006', '2016-02-09', '502', '16:00', '0:00'),
('2007', '2016-02-09', '503', '0:00', '8:00'),
('2008', '2016-02-09', '503', '8:00', '16:00'),
('2009', '2016-02-09', '503', '16:00', '0:00'),
('2010', '2016-02-09', '509', '0:00', '8:00'),
('2011', '2016-02-09', '509', '8:00', '16:00'),
('2012', '2016-02-09', '509', '16:00', '0:00'),
('2013', '2016-02-09', '508', '0:00', '8:00'),
('2014', '2016-02-09', '508', '8:00', '16:00'),
('2015', '2016-02-09', '508', '16:00', '0:00'),
('2016', '2016-02-09', '507', '0:00', '8:00'),
('2017', '2016-02-09', '507', '8:00', '16:00'),
('2018', '2016-02-09', '507', '16:00', '0:00');


/*Inserimento valori nella tabella Amministrativo*/
INSERT INTO Amministrativo(ID_Amm, Nome, Cognome, DataN, Stipendio, Ruolo) VALUES
('301', 'Marco', 'De Marco', '1985-01-05', '55000', 'Direttore'),
('302', 'Paolo', 'Zampinetti', '1985-05-13', '20000', 'Segreteria'),
('303', 'Luca', 'Rossato', '1965-11-11', '20000', 'Segreteria'),
('304', 'GianMaria', 'Franceschini', '1990-12-21', '22000', 'Segreteria'),
('305', 'Lucrezia', 'De Franceschi', '1946-09-22', '23000', 'Segreteria'),
('306', 'Giuseppina', 'De Paoli', '1965-04-15', '22000', 'Responsabile Lavoro'),
('307', 'Anna', 'De Luca', '1959-07-19', '24500', 'Responsabile Lavoro'),
('308', 'Paola', 'De Marco', '1956-09-03', '23500', 'Responsabile Lavoro'),
('309', 'Luca', 'Bruschi', '1995-06-07', '22500', 'Responsabile Lavoro'),
('310', 'Pippo', 'Giusti', '1966-09-03', '24500', 'Responsabile Lavoro'),
('311', 'Claudia', 'Bianchi', '1965-04-15', '23000', 'Responsabile Lavoro'),
('312', 'Claudio', 'Verdi', '1965-05-12', '23000', 'Responsabile Lavoro'),
('313', 'Francesco', 'Rossi', '1976-11-12', '25000', 'Responsabile Lavoro'),
('314', 'Francesca', 'Richieni', '1985-01-05', '23500', 'Responsabile Lavoro'),
('315', 'Michela', 'Francia', '1971-08-07', '24500', 'Responsabile Lavoro'),
('316', 'Michele', 'Mali', '1990-05-18', '19000', 'Responsabile Lavoro'),
('317', 'Pino', 'Giusti', '1988-09-19', '20000', 'Responsabile Lavoro'),
('318', 'Pina', 'Lora', '1989-09-19', '21000', 'Responsabile Archivi'),
('319', 'Maria', 'Giuseppini', '1992-01-07', '21500', 'Responsabile Archivi'),
('320', 'Maria', 'Marchi', '1977-07-11', '22000', 'Responsabile Archivi');


/*Inserimento valori nella tabella AziendaAppaltata*/
INSERT INTO AziendaAppaltata(pIVA, Nome, Recapito, Indirizzo) VALUES
('IT328384958', 'Cooperativa Il Fiore', '442394858', 'Via Milano 12, Padova'),
('IT118394857', 'Coop. Futuro Sostenibile', '444929283', 'Via Venezia 5, Vicenza'),
('IT023948575', 'Bianchi Costruzioni', '444098398', 'Via Roma 200, Padova'),
('IT923847838', 'Coop. Primula', '459898988', 'Via delle Rose, 12, Venezia');


/*Inserimento valori nella tabella Lavoro*/
INSERT INTO Lavoro(CodL, Descrizione, RetrOraria, Max, Tipo, pIVA, Responsabile) VALUES 
('1020', 'Cucina', '3', '20', 'interno', NULL, '307'),
('1021', 'Costruzioni', '6', '20', 'esterno', 'IT328384958', NULL),
('1022', 'Pulizia Blocco1', '7', '30', 'interno', NULL, '312'),
('1023', 'Pulizia Blocco2', '3', '10', 'interno', NULL, '313'),
('1050', 'Giardinaggio', '6', '15', 'esterno', 'IT118394857', NULL),
('1051', 'Pittura', '4', '10', 'esterno', 'IT023948575', NULL),
('1055', 'Pulizia Blocco3', '5', '10', 'interno', NULL, '308'),
('1060', 'Pulizia Zone Comuni', '6', '20', 'interno', NULL, '316'),
('1066', 'Lavoro nei campi', '7', '20', 'esterno', 'IT923847838', NULL),
('1150', 'Archiviazione', '5', '25', 'interno', NULL, '310');


/*Inserimento valori nella tabella Turno*/
INSERT INTO Turno(Data, Codice, OraI, OraF) VALUES
('2016-02-09', '1020', '10:00', '13:00'),
('2016-02-09', '1021', '15:00', '18:00'),
('2016-03-09', '1022', '16:00', '18:00'),
('2016-03-09', '1023', '10:00', '12:00'),
('2016-04-09', '1050', '15:00', '17:00'),
('2016-04-09', '1051', '16:00', '18:00'),
('2016-05-09', '1055', '13:00', '14:00'),
('2016-05-09', '1060', '16:00', '17:00'),
('2016-06-09', '1066', '15:00', '17:00'),
('2016-06-09', '1150', '10:00', '11:00');


/*Inserimento valori nella tabella RegistroImpieghi*/
INSERT INTO RegistroImpieghi(Det, Lavoro, DataI, DataF) VALUES
('1001', '1020', '2013-12-12', '2014-02-03'),
('1001', '1021', '2014-02-03', '2015-05-05'),
('1001', '1022', '2015-05-05', '2016-12-08'),
('1002', '1020', '2015-10-22', '2016-02-06'),
('1003', '1020', '2015-05-05', '2015-11-13'),
('1003', '1050', '2015-11-13', '2016-03-17'),
('1004', '1060', '2015-10-14', '2016-02-03'),
('1005', '1023', '2016-08-24', '2016-12-08'),
('1008', '1066', '2015-12-16', '2016-05-05'),
('1009', '1150', '2016-05-18', '2016-12-08'),
('1010', '1020', '2015-12-05', '2016-05-25'),
('1011', '1020', '2015-10-10', '2016-08-23');


/*Inserimento valori nella tabella ImpieghiAttuali*/
INSERT INTO ImpieghiAttuali(Det, Lavoro, DataI) VALUES 
('1001', '1021', '2016-04-19'),
('1002', '1022', '2016-02-06'),
('1003', '1023', '2016-03-17'),
('1004', '1020', '2016-02-03'),
('1005', '1050', '2016-06-14'),
('1006', '1051', '2016-02-15'),
('1007', '1055', '2016-07-12'),
('1008', '1060', '2016-05-05'),
('1009', '1066', '2016-12-08'),
('1010', '1150', '2016-05-25'),
('1011', '1021', '2016-04-18'),
('1012', '1022', '2016-08-27'),
('1013', '1023', '2016-08-22'),
('1014', '1020', '2016-04-11'),
('1015', '1050', '2016-03-14'),
('1016', '1051', '2015-09-25'),
('1017', '1055', '2016-08-30'),
('1018', '1060', '2015-10-05'),
('1019', '1066', '2015-11-23'),
('1020', '1150', '2016-04-18');


/*Inserimento valori nella tabella Attività*/
INSERT INTO Attività(CodAtt, Descrizione, Max) VALUES
('701', 'Corso cucito', '20'),
('702', 'Istruzione elementare', '20'),
('703', 'Istruzione superiore', '30'),
('704', 'Calcio', '20'),
('705', 'Teatro', '12'),
('706', 'Pallavolo', '22'),
('707', 'Tennis', '7'),
('708', 'Rugby', '18');

/*Inserimento valori nella tabella RegistroAttività*/
INSERT INTO RegistroAttività(AttSvolta, Rep, GiornoSett, OraI, OraF) VALUES
('701', '507', 'mar', '10:00', '12:00'),
('701', '507', 'mer', '14:00', '16:00'),
('701', '507', 'gio', '14:00', '16:00'),
('702', '505', 'lun', '10:00', '12:00'),
('702', '505', 'mer', '10:00', '12:00'),
('702', '505', 'gio', '14:00', '16:00'),
('703', '505', 'lun', '14:00', '16:00'),
('703', '505', 'mer', '14:00', '16:00'),
('703', '505', 'gio', '10:00', '12:00'),
('704', '510', 'ven', '18:00', '20:00'),
('704', '510', 'sab', '18:00', '20:00'),
('704', '510', 'dom', '10:00', '12:00'),
('705', '504', 'mar', '20:00', '22:00'),
('705', '504', 'mer', '18:00', '20:00'),
('705', '504', 'gio', '20:00', '22:00'),
('706', '506', 'mar', '20:00', '21:00'),
('706', '504', 'gio', '20:00', '22:00'),
('706', '504', 'ven', '18:00', '20:00'),
('707', '504', 'lun', '10:00', '11:00'),
('707', '504', 'lun', '11:00', '12:00'),
('708', '510', 'sab', '9:00', '11:00'),
('708', '510', 'dom', '14:00', '16:00');

/*Inserimento valori nella tabella Iscritti*/
INSERT INTO Iscritti(Matricola, Attività) VALUES
('1001', '708'),
('1002', '707'),
('1003', '706'),
('1004', '705'),
('1005', '704'),
('1006', '703'),
('1007', '702'),
('1008', '701'),
('1009', '708'),
('1010', '707'),
('1011', '706'),
('1012', '705'),
('1013', '704'),
('1014', '703'),
('1015', '702'),
('1016', '701'),
('1017', '704'),
('1018', '703'),
('1019', '706'),
('1020', '701'),
('1001', '702'),
('1013', '706'),
('1008', '707'),
('1004', '701'),
('1002', '706');

/*Inserimento valori nella tabella Educatore*/
INSERT INTO Educatore(ID_Educatore, Nome, Cognome, DataN, Stipendio, Laurea, Attività, pIVA) VALUES
('201', 'Marco', 'Rossi', '1990-01-12', '12000', 'Belle Arti', '701', 'IT923847838'),
('202', 'Paola', 'Bianchi', '1968-01-02', '15000', 'Scienze Educazione', '702', 'IT118394857'),
('203', 'Luca', 'Rossato', '1988-12-12', '18000', 'Matematica', '703', 'IT118394857'),
('204', 'Giovanni', 'Lora', '1989-05-05', '20000', 'Scienze Motorie', '704', 'IT328384958'),
('205', 'Claudio', 'Rossi', '1983-07-21', '15000', 'Belle Arti', '705', 'IT923847838'),
('206', 'Michele', 'Paolini', '1968-12-05', '13000', 'Scienze Motorie', '706', 'IT328384958'),
('207', 'Tommaso', 'De Marchi', '1977-10-26', '10000', 'Scienze Motorie', '707', 'IT328384958'),
('208', 'Francesca', 'Giusti', '1978-02-07', '12000', 'Scienze Motorie', '708', 'IT328384958');

/* Procedura accredito */
CREATE PROCEDURE AccreditoCC (ValoreA INT(4), Lavoro INT(4))
UPDATE ContoCorrente CC JOIN ImpieghiAttuali IA ON CC.Mat = IA.Det
SET CC.Saldo = CC.Saldo + ValoreA
WHERE IA.Lavoro = Lavoro;


/* Selezionare nome, cognome e lavoro svolto da tutti i detenuti con più di 25 anni che svolgono un lavoro fuori dall’istituto */
CREATE VIEW LavoriFuori AS
SELECT D.Nome AS Nome, D.Cognome AS Cognome, L.Descrizione 
FROM Detenuto D, ImpieghiAttuali I, Lavoro L
WHERE D.Mat = I.Det AND I.Lavoro = L.CodL AND round(datediff(now(),D.DataN)/365)>25 AND L.Tipo = 'esterno';

/* Selezionare nome, cognome e stanza dei detenuti che fanno parte del Blocco1 */
CREATE VIEW DetBlocco1 AS
SELECT D.Nome, D.Cognome, S.Numero
FROM Detenuto D, Stanza S
WHERE D.Numero = S.Numero AND S.Blocco = 501;

/* Selezionare il nome e il cognome dei responsabili che supervisionano le attività che si svolgono di lunedì, 
indicando anche che attività si svolge e in quale reparto */
CREATE VIEW RespAttività AS
SELECT DISTINCT G.Nome, G.Cognome, R.Nome as 'Nome Reparto', A.Descrizione
FROM Guardia G JOIN Reparto R ON G.ID_Guardia = R.Responsabile JOIN RegistroAttività RA ON R.CodR = RA.Rep JOIN Attività A ON RA.AttSvolta = A.CodAtt
WHERE RA.GiornoSett = 'lun';

/* Per ogni attività, seleziona la descrizione, il nome e cognome dell’educatore e il numero di iscritti. */
CREATE VIEW NumIscritti AS
SELECT A.Descrizione, E.Nome, E.Cognome, H0.Partecipanti
FROM Attività A JOIN Educatore E  ON A.CodAtt = E.Attività 
LEFT JOIN (SELECT I.Attività, COUNT(I.Matricola) as Partecipanti FROM Iscritti I GROUP BY I.Attività) H0 ON A.CodAtt = H0.Attività;

/* Per ogni reparto si vuole sapere la media dei soldi in CC dei detenuti che risiedono nel blocco */
CREATE VIEW RicchezzaBlocco AS
SELECT R.Nome, AVG(CC.Saldo) as SaldoMedio
FROM Reparto R JOIN Stanza S ON R.CodR = S.Blocco JOIN Detenuto D ON S.Numero = D.Numero JOIN ContoCorrente CC ON D.Mat = CC.Mat
GROUP BY R.Nome;