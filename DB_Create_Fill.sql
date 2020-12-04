
DROP SCHEMA IF EXISTS Labo2;
CREATE SCHEMA Labo2 DEFAULT CHARSET = utf8mb4;
USE Labo2;




CREATE TABLE Discipline (
	code CHAR(3),
	nom VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Discipline PRIMARY KEY (code)
) ENGINE = InnoDB;


CREATE TABLE Pays (
	id INTEGER UNSIGNED AUTO_INCREMENT,
	nom VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Pays PRIMARY KEY (id),
	CONSTRAINT UC_Pays_nom UNIQUE (nom)
) ENGINE = InnoDB;


CREATE TABLE Federation (
	id INTEGER UNSIGNED AUTO_INCREMENT,
	idPays INTEGER UNSIGNED NOT NULL,
	nom VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Federation PRIMARY KEY (id),
	CONSTRAINT UC_Federation_nom UNIQUE (nom),
	CONSTRAINT FK_Federation_idPays
		FOREIGN KEY (idPays)
		REFERENCES Pays (id)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Personne (
	id INTEGER UNSIGNED AUTO_INCREMENT,
	idPays INTEGER UNSIGNED NOT NULL,
	nom VARCHAR(50) NOT NULL,
	prenom VARCHAR(50) NOT NULL,
	dateNaissance TIMESTAMP NOT NULL,
	CONSTRAINT PK_Personne PRIMARY KEY (id),
	CONSTRAINT FK_Personne_idPays
		FOREIGN KEY (idPays)
		REFERENCES Pays (id)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Coach (
	idPersonne INTEGER UNSIGNED,
	codeDiscipline CHAR(3) NOT NULL,
	CONSTRAINT PK_Coach PRIMARY KEY (idPersonne),
	CONSTRAINT FK_Coach_idPersonne
		FOREIGN KEY (idPersonne)
		REFERENCES Personne (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_Coach_codeDiscipline
		FOREIGN KEY (codeDiscipline)
		REFERENCES Discipline (code)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Gymnaste (
	idPersonne INTEGER UNSIGNED,
	idCoach INTEGER UNSIGNED,
	idFederation INTEGER UNSIGNED NOT NULL,
	CONSTRAINT PK_Gymnaste PRIMARY KEY (idPersonne),
	CONSTRAINT FK_Gymnaste_idPersonne
		FOREIGN KEY (idPersonne)
		REFERENCES Personne (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_Gymnaste_idCoach
		FOREIGN KEY (idCoach)
		REFERENCES Coach (idPersonne)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
	CONSTRAINT FK_Gymnaste_idFederation
		FOREIGN KEY (idFederation)
		REFERENCES Federation (id)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Gymnaste_Discipline (
	idGymnaste INTEGER UNSIGNED,
	codeDiscipline CHAR(3),
	CONSTRAINT PK_Gymnaste_Discipline PRIMARY KEY (idGymnaste, codeDiscipline),
	CONSTRAINT FK_Gymnaste_Discipline_idGymnaste
		FOREIGN KEY (idGymnaste)
		REFERENCES Gymnaste (idPersonne)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
	CONSTRAINT FK_Gymnaste_Discipline_codeDiscipline
		FOREIGN KEY (codeDiscipline)
		REFERENCES Discipline (code)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Evenement (
	id INTEGER UNSIGNED AUTO_INCREMENT,
	idFederation INTEGER UNSIGNED NOT NULL,
	nom VARCHAR(50) NOT NULL,
	dateOuverture TIMESTAMP NOT NULL,
	fraisInscription INTEGER NOT NULL,
	CONSTRAINT PK_Evenement PRIMARY KEY (id),
	CONSTRAINT UC_Evenement_nom UNIQUE (nom),
	CONSTRAINT FK_Evenement_idFederation
		FOREIGN KEY (idFederation)
		REFERENCES Federation (id)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;


CREATE TABLE Inscription (
	idGymnaste INTEGER UNSIGNED,
	idEvenement INTEGER UNSIGNED,
	date TIMESTAMP NOT NULL,
	CONSTRAINT PK_Inscription PRIMARY KEY (idGymnaste, idEvenement),
	CONSTRAINT FK_Inscription_idGymnaste
		FOREIGN KEY (idGymnaste)
		REFERENCES Gymnaste (idPersonne)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
	CONSTRAINT FK_Inscription_idEvenement
		FOREIGN KEY (idEvenement)
		REFERENCES Evenement (id)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE = InnoDB;



CREATE VIEW vCoach
AS
	SELECT
		id,
		nom,
		prenom,
		dateNaissance,
		idPays,
		codeDiscipline
	FROM
		Coach
		INNER JOIN Personne ON
			Coach.idPersonne = Personne.id;


CREATE VIEW vGymnaste
AS
	SELECT
		id,
		nom,
		prenom,
		dateNaissance,
		idPays,
		idFederation,
		idCoach
	FROM
		Gymnaste
		INNER JOIN Personne ON
			Gymnaste.idPersonne = Personne.id;










INSERT INTO Discipline (code, nom) VALUES ('GFA', 'Gymnastics For All');
INSERT INTO Discipline (code, nom) VALUES ('RGI', 'Rhythmic Individual');
INSERT INTO Discipline (code, nom) VALUES ('AER', 'Aerobic Gymnastics');
INSERT INTO Discipline (code, nom) VALUES ('TRA', 'Trampoline');


INSERT INTO Pays (nom) VALUES ('Switzerland');
INSERT INTO Pays (nom) VALUES ('Great Britain');
INSERT INTO Pays (nom) VALUES ('Spain');
INSERT INTO Pays (nom) VALUES ('Canada');
INSERT INTO Pays (nom) VALUES ('Burkina Faso');


INSERT INTO Federation (nom, idPays) VALUES ('FEDERATION SUISSE DE GYMNASTIQUE', (SELECT id FROM Pays WHERE nom = 'Switzerland'));
INSERT INTO Federation (nom, idPays) VALUES ('BRITISH GYMNASTICS', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Federation (nom, idPays) VALUES ('REAL FEDERACION ESPANOLA DE GIMNASIA', (SELECT id FROM Pays WHERE nom = 'Spain'));
INSERT INTO Federation (nom, idPays) VALUES ('CANADIAN GYMNASTICS FEDERATION', (SELECT id FROM Pays WHERE nom = 'Canada'));


INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('VII Copa Interacional Catalunya', '2021-11-23', 50, (SELECT id FROM Federation WHERE nom = 'REAL FEDERACION ESPANOLA DE GIMNASIA'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('FIG World Cup 2019 - GFA - TRA', '2019-09-14', 20, (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('FIG World Cup 2019 - RGI', '2019-09-14', 10, (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('FIG World Cup 2019 - AER', '2019-09-14', 8, (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('FIG World Cup 2018', '2018-07-14', 40, (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('Match Junior SUI-FRA-GER 2018', '2018-03-09', 100, (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('FIG World Cup 2017', '2017-03-09', 150, (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('VIII Copa Interacional Catalunya', '2025-11-23', 40, (SELECT id FROM Federation WHERE nom = 'REAL FEDERACION ESPANOLA DE GIMNASIA'));
INSERT INTO Evenement (nom, dateOuverture, fraisInscription, idFederation) VALUES ('TRA RGI World Cup 2018', '2018-03-12', 80, (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));


INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Hernandez', 'Luis', '1982-11-08', (SELECT id FROM Pays WHERE nom = 'Spain'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'AER');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Gallardo', 'Gabriel', '1972-05-06', (SELECT id FROM Pays WHERE nom = 'Spain'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'AER');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Bérubé', 'Vincent', '1989-01-30', (SELECT id FROM Pays WHERE nom = 'Canada'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Schmid', 'Hans', '1979-01-30', (SELECT id FROM Pays WHERE nom = 'Switzerland'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Traore', 'Aicha', '1991-02-27', (SELECT id FROM Pays WHERE nom = 'Burkina Faso'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Hunt', 'Finley', '1990-06-01', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Coach (idPersonne, codeDiscipline) VALUES ((SELECT MAX(id) FROM Personne), 'GFA');


INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Plaisance', 'Isabella', '2000-11-08', (SELECT id FROM Pays WHERE nom = 'Spain'));
INSERT INTO Gymnaste (idPersonne, idFederation) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'REAL FEDERACION ESPANOLA DE GIMNASIA'));
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Aguas', 'Shaunta', '1982-11-07', (SELECT id FROM Pays WHERE nom = 'Spain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'REAL FEDERACION ESPANOLA DE GIMNASIA'), 1);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Lubinsky', 'Al', '2002-11-08', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'CANADIAN GYMNASTICS FEDERATION'));
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Vaillancourt', 'Laurence', '1971-11-08', (SELECT id FROM Pays WHERE nom = 'Canada'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'CANADIAN GYMNASTICS FEDERATION'), 2);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Deeann', 'Hibbert', '2011-11-07', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'CANADIAN GYMNASTICS FEDERATION'), 1);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Defazio', 'Annice', '2000-12-08', (SELECT id FROM Pays WHERE nom = 'Switzerland'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'), 1);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Burgdorf', 'Providencia', '2000-11-08', (SELECT id FROM Pays WHERE nom = 'Switzerland'));
INSERT INTO Gymnaste (idPersonne, idFederation) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'));
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Weinberger', 'Ozie', '2000-06-08', (SELECT id FROM Pays WHERE nom = 'Switzerland'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'), 5);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Nygaard', 'Preston', '1998-10-08', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'), 5);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Harvell', 'Harold', '1999-11-08', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'), 6);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Hutson', 'Dwight', '1977-03-04', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'), 5);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Lovelace', 'Gena', '2002-11-14', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'));
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Halls', 'Krysta', '1993-03-03', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'BRITISH GYMNASTICS'), 6);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Hinrichs', 'Shiela', '2001-05-30', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'REAL FEDERACION ESPANOLA DE GIMNASIA'));
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');

INSERT INTO Personne(nom, prenom, dateNaissance, idPays) VALUES ('Bender', 'Leeann', '2002-03-28', (SELECT id FROM Pays WHERE nom = 'Great Britain'));
INSERT INTO Gymnaste (idPersonne, idFederation, idCoach) VALUES ((SELECT MAX(id) FROM Personne), (SELECT id FROM Federation WHERE nom = 'FEDERATION SUISSE DE GYMNASTIQUE'), 6);
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'AER');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'RGI');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'TRA');
INSERT INTO Gymnaste_Discipline (idGymnaste, codeDiscipline) VALUES ((SELECT MAX(idPersonne) FROM Gymnaste), 'GFA');


INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (7, 1, '2019-10-24');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (9, 2, '2017-10-24');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (19, 2, '2018-01-24');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (21, 2, '2018-03-22');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (8, 4, '2018-12-24');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (7, 5, '2018-05-11');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (8, 5, '2018-05-11');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (9, 5, '2018-05-12');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (10, 5, '2018-05-13');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (11, 5, '2018-05-14');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (12, 5, '2018-05-15');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (13, 5, '2018-05-16');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (14, 5, '2018-05-17');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (15, 5, '2018-05-18');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (17, 5, '2018-05-20');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (18, 5, '2018-05-24');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (19, 5, '2018-05-22');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (20, 5, '2018-05-23');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (21, 5, '2018-05-24');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (21, 7, '2017-03-10');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (7, 8, '2019-10-21');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (11, 8, '2019-10-24');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (12, 8, '2019-11-01');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (20, 8, '2019-11-11');

INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (13, 9, '2018-04-14');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (14, 9, '2018-03-12');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (8, 9, '2017-10-24');
INSERT INTO Inscription (idGymnaste, idEvenement, date) VALUES (9, 9, '2017-12-01');