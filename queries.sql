/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered=true AND escape_attempts<3;

-- List date of birth of all animals named either "Agumon" or "Pikachu".
SELECT  date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg>10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered=true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE NOT name='Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* update table */

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT species FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT species FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;

/* Delete all animals born after Jan 1st, 2022. */
BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '01/01/2022';
/* Create a savepoint for the transaction. */
SAVEPOINT DELETE_DOB;
/* Update all animals' weight to be their weight multiplied by -1. */
UPDATE animals SET weight_kg = (weight_kg * -1);
/* Rollback to the savepoint */
ROLLBACK TO DELETE_DOB;
/* Update all animals' weights that are negative to be their weight multiplied by -1. */
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0; 
/* Commit transaction */
COMMIT TRANSACTION;

/* How many animals are there? */
SELECT COUNT(*) FROM animals;
/* How many animals have never tried to escape? */
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
/* What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;
/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
/* What is the minimum and maximum weight of each type of animal? */
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species, AVG(escape_attempts) FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 1990 AND 2000 GROUP BY species;


/* What animals belong to Melody Pond? */
SELECT name FROM animals
    INNER JOIN owners
    ON owners.id = animals.owner_id
    AND owners.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT animals.name FROM animals
    INNER JOIN species
    ON species.id = animals.species_id
    AND species.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT full_name, name FROM owners
LEFT JOIN animals ON owners.id=animals.owner_id;

/* How many animals are there per species? */
SELECT species.name, COUNT(*) FROM species
INNER JOIN animals ON animals.species_id=species.id
GROUP BY species.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT name FROM animals
INNER JOIN owners ON animals.owner_id=owners.id
WHERE owners.full_name='Jennifer Orwell' 
AND animals.species_id=(SELECT id FROM species WHERE name='Digimon');

/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT name FROM animals
INNER JOIN owners ON animals.owner_id=owners.id
WHERE owners.full_name='Dean Winchester' 
AND animals.escape_attempts=0;

/* Who owns the most animals? */
SELECT owners.full_name, COUNT(*) as count FROM owners join animals ON animals.owner_id=owners.id
GROUP BY full_name
ORDER BY count DESC