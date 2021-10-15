/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

ALTER TABLE animals ADD COLUMN species VARCHAR(100);

/* Create a table OWNERS */

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50),
    age INT,
    PRIMARY KEY(id)
);

/* Create a table named SPECIES */
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    PRIMARY KEY(id)
);

/* Remove column species */
ALTER TABLE animals DROP COLUMN species;
/* Add column species_id which is a foreign key referencing species table */
ALTER TABLE animals ADD COLUMN species_id INTEGER;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);
/* Add column owner_id which is a foreign key referencing the owners table */
ALTER TABLE animals ADD COLUMN owner_id INTEGER;
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

/* Create 'vets' table */
CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY(id)
);

/* Create 'specializations' table */
CREATE TABLE specializations (
  species_id INT REFERENCES species(id),
  vet_id INT REFERENCES vets(id)
);

/* add UNIQUE constraint */
ALTER TABLE animals 
ADD CONSTRAINT unique_id UNIQUE (id);

/* Create 'visits' table */
CREATE TABLE visits (
    id INT GENERATED ALWAYS AS IDENTITY,
    animals_id  INT,
    vets_id     INT,
    date_of_visit DATE,
    FOREIGN KEY (animals_id) REFERENCES animals (id),
    FOREIGN KEY (vets_id) REFERENCES vets (id),
    PRIMARY KEY (id)
);

/* audit */

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Optimize visits table by creating an Index using the animals_id column
CREATE INDEX animals_id_asc ON visits (animals_id ASC);

-- Optimize visits table by creating an Index using the vets_id column
CREATE INDEX vets_id_asc ON visits (vets_id ASC);

-- -- Optimize owners table by creating an Index using the email column
CREATE INDEX owners_email_asc ON owners (email ASC);