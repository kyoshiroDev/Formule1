USE course_f1;

# Permet avec le DROP de supprimer la table avant de l'ajouter a nouveau
DROP TABLE IF EXISTS course_pilote;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS circuit;
DROP TABLE IF EXISTS pilote;
DROP TABLE IF EXISTS equipe;
DROP VIEW IF EXISTS score_pilote;

-- Creation table course
CREATE TABLE circuit(
    # Premiere façon d'écrire un id auto increment
    circuit_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(50),
    nom VARCHAR(50),
    longueur FLOAT # km
);

# Creation table course
CREATE TABLE course(
    # Deuxieme façon d'écrire un id auto increment
    course_id INTEGER AUTO_INCREMENT,
    CONSTRAINT course_PK PRIMARY KEY  (course_id),
    nom VARCHAR(255),
    date_course DATE,
    # La migration de la clé
    circuit_id INTEGER,
    # circuit-id ne viens pas de moi mais de la colonne circuit_id de circuit
    FOREIGN KEY (circuit_id) REFERENCES circuit(circuit_id)
);

# Creation table equipe
CREATE TABLE equipe(
    equipe_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(255),
    nom VARCHAR(255) NOT NULL,
    directeur_technique VARCHAR(255)
);

# Creation table pilote
CREATE TABLE pilote(
    pilote_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    nationalite VARCHAR (255),
    date_naissance DATE,
    equipe_id INTEGER,
    FOREIGN KEY (equipe_id) REFERENCES equipe(equipe_id)
);

# Creation table participe
CREATE TABLE course_pilote(
    pilote_id INTEGER,
    course_id INTEGER,
    position_pilote INTEGER NOT NULL,
    FOREIGN KEY (pilote_id) REFERENCES pilote(pilote_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    # Ajouter une primary key a pilote_id et course_id
    CONSTRAINT course_pilote_pk PRIMARY KEY (pilote_id, course_id)
);

# Creation d'un index : augmentation des performances
# Attention, cela prend de la place sur le disque
CREATE INDEX index_pays ON circuit(pays);

# Je sais à l'avance que je vais avoir besoin de lancer plusieurs fois la requete
# Création d'un objet SQL
CREATE VIEW score_pilote AS
(SELECT p.nom as 'nom_pilote', p.prenom, c.nom as 'nom_course', c.date_course, cp.position_pilote
FROM pilote p
JOIN course_pilote cp ON p.pilote_id = cp.pilote_id
JOIN course as c ON c.circuit_id = cp.course_id
);

# Inserer des données
INSERT INTO circuit(pays, nom, longueur) VALUES ('France','Jose',2.5),
                                                ('Espagne','Josette',4),
                                                ('Belgique','Herve',5);
INSERT INTO course(nom, date_course, circuit_id) VALUE ('test',CURDATE(),1);
INSERT INTO course(nom, date_course, circuit_id) VALUE ('course ecolo','2024-10-09',2);
INSERT INTO equipe (pays, nom, directeur_technique) VALUE ('FRANCE', 'Studi', 'Jose');
INSERT INTO pilote (nom, prenom, nationalite, date_naissance, equipe_id) VALUES ('Michel', 'Augustin',
                                                                                 'FRancaise',
                                                                                 '2023-10-09',
                                                                                 1);
INSERT INTO pilote (nom, prenom, nationalite, date_naissance, equipe_id) VALUES ('Josette', 'Jesaispas',
                                                                                 'FRancaise',
                                                                                 '2023-10-09',
                                                                                 1);

# 1. je veux rajouter un compteur de course sur les pilotes
ALTER TABLE pilote ADD COLUMN compteur_course INTEGER NOT NULL;

# Automatisation du compteur suite à une nouvelle insertion dans course_pilote avec un trigger
CREATE OR REPLACE TRIGGER update_compteur_pilote
    AFTER INSERT ON course_pilote
    FOR EACH ROW
    BEGIN
        # on a le traitement d'incrémentation
        UPDATE pilote
        SET compteur_course = compteur_course + 1
        WHERE pilote_id = NEW.pilote_id;
    END;

# Vue 1
INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (1,1,5);
INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (1,2,3);

# Appel de la vue : 1
SELECT * FROM score_pilote;

# Vue 2
INSERT INTO course_pilote (pilote_id, course_id, position_pilote) VALUE (2,2,2);
# Appel de la vue : 2
SELECT * FROM score_pilote;

# Affichage table pilote
SELECT * FROM pilote;









