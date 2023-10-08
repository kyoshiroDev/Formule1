# Permet avec le DROP de supprimer la table avant de l'ajouter a nouveau
DROP TABLE IF EXISTS circuit;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS equipe;
DROP TABLE IF EXISTS pilote;
DROP TABLE IF EXISTS course_pilote;

-- Creation table course
CREATE TABLE circuit(
    # Premiere façon d'écrire un id auto increment
    circuit_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    pays VARCHAR(50),
    nom VARCHAR(50),
    longueur FLOAT
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