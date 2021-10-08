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