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


/* Who was the last animal seen by William Tatcher? */
SELECT visit.animalName, visit.date_of_visit FROM (SELECT vets.name as vetName, animals.name as animalName, visits.date_of_visit
FROM animals 
JOIN visits on (animals.id=visits.animals_id)
JOIN vets on (vets.id=visits.vets_id)) as visit
WHERE vetName='William Tatcher'
ORDER BY date_of_visit DESC
LIMIT 1;

/* How many different animals did Stephanie Mendez see? */
SELECT COUNT(DISTINCT visits.animals_id) FROM visits
    INNER JOIN vets ON vets.id = visits.vets_id
    WHERE vets.name = 'Stephanie Mendez';

/* List all vets and their specialties, including vets with no specialties. */
SELECT vets.name, species.name FROM vets 
    LEFT JOIN specializations ON specializations.vet_id = vets.id
    LEFT JOIN species ON species.id = specializations.species_id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT animals.name, visits.date_of_visit FROM visits
    INNER JOIN vets ON vets.id = visits.vets_id
    INNER JOIN animals ON animals.id = visits.animals_id
    WHERE vets.name = 'Stephanie Mendez'
    AND visits.date_of_visit BETWEEN '01-04-2020' AND '30-08-2020';

/* What animal has the most visits to vets? */
SELECT name, COUNT(*) as count FROM animals
JOIN visits on animals.id=visits.animals_id
GROUP BY name
ORDER BY count DESC
LIMIT 1;

/* Who was Maisy Smith's first visit? */
SELECT animals.name, visits.date_of_visit AS first_visit FROM visits
    INNER JOIN vets ON vets.id = visits.vets_id
    INNER JOIN animals ON animals.id = visits.animals_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY animals.name, visits.date_of_visit
    ORDER BY first_visit LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT  animals.name, vets.name, visits.date_of_visit
FROM animals 
JOIN visits on (animals.id=visits.animals_id)
JOIN vets on (vets.id=visits.vets_id)
ORDER BY date_of_visit DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(visits.animals_id) FROM visits
    INNER JOIN vets ON vets.id = visits.vets_id
    INNER JOIN animals ON animals.id = visits.animals_id
    INNER JOIN specializations ON specializations.vet_id = vets.id
    WHERE specializations.species_id <> animals.species_id;


/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT species.name, COUNT(visits.animals_id) AS species_count FROM visits
    INNER JOIN vets ON vets.id = visits.vets_id
    INNER JOIN animals ON animals.id = visits.animals_id
    INNER JOIN species ON species.id = animals.species_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY species.name
    ORDER BY species_count DESC LIMIT 1;