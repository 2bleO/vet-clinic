/* Populate database with sample data. */

INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Agumon', '03/02/2020', 0, TRUE, 10.23);
INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Gabumon', '15/11/2020', 2, TRUE, 8);
INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Pikachu', '07/10/2021', 1, FALSE, 15.04);
INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Devimon', '12/05/2017', 5, TRUE, 11);

/* Update table */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Charmander', '08/02/2020', 0, false, -11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Plantmon', '15/11/2022', 2, true, -5.7);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Squirtle', '02/04/1993', 3, false, -12.13);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Angemon', '12/06/2005', 1 , true, -45);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Boarmon', '07/06/2005', 7, true, 20.04);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES('Blossom', '13/10/1998', 3, true, 17);

/* Insert data into the owners table */
INSERT INTO owners (full_name, age) VALUES  ('Sam Smith',  34), ('Jennifer Orwell', 19), ('Bob', 45), ('Melody Pond', 77), ('Dean Winchester', 14), ('Jodie Whittaker', 38);
/* Insert data into the species table */
INSERT INTO species (name) VALUES('Pokemon'), ('Digimon');

/* Modify inserted animals so it includes the species_id value: */
  UPDATE animals
  SET species_id=(SELECT id FROM species WHERE name='Digimon')
  WHERE name LIKE '%mon';
  -- All other animals are Pokemon
  UPDATE animals
  SET species_id=(SELECT id FROM species WHERE name='Pokemon')
  WHERE species_id IS NULL;

  -- Modify your inserted animals to include owner information (owner_id):
  UPDATE animals
  SET owner_id=(SELECT id FROM owners WHERE full_name='Sam Smith')
  WHERE name='Agumon';

  UPDATE animals
  SET owner_id=(SELECT id FROM owners WHERE full_name='Jennifer Orwell')
  WHERE name IN('Gabumon', 'Pikachu');

  UPDATE animals
  SET owner_id=(SELECT id FROM owners WHERE full_name='Bob')
  WHERE name IN('Devimon', 'Plantmon');

  UPDATE animals
  SET owner_id=(SELECT id FROM owners WHERE full_name='Melody Pond')
  WHERE name IN('Charmander', 'Squirtle', 'Blossom');

  UPDATE animals
  SET owner_id=(SELECT id FROM owners WHERE full_name='Dean Winchester')
  WHERE name IN('Angemon', 'Boarmon');


/* Insert data for 'vets' */
INSERT INTO vets (name, age, date_of_graduation) VALUES ('William Tatcher',  45, '23-04-2000'), ('Maisy Smith', 26, '17-01-2019'), ('Stephanie Mendez', 64, '04-05-1981'), ('Jack Harkness', 38, '08-06-2008');

/* Insert data for 'specializations' */
INSERT INTO specializations (vet_id, species_id) 
                    VALUES ((SELECT id FROM vets WHERE name='William Tatcher'), (SELECT id FROM species WHERE name='Pokemon')),
                           ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM species WHERE name='Digimon')),
                           ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM species WHERE name='Pokemon')),
                           ((SELECT id FROM vets WHERE name='Jack Harkness'), (SELECT id FROM species WHERE name='Digimon'));

/* Insert the data for visits: */
INSERT INTO visits (vets_id, animals_id, date_of_visit) 
                    VALUES ((SELECT id FROM vets WHERE name='William Tatcher'), (SELECT id FROM animals WHERE name='Agumon'), '24-05-2020'),
                            ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM animals WHERE name='Agumon'), '22-04-2020'),
                            ((SELECT id FROM vets WHERE name='Jack Harkness'), (SELECT id FROM animals WHERE name='Gabumon'), '02-02-2021'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Pikachu'), '05-01-2020'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Pikachu'), '08-03-2020'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Pikachu'), '14-05-2020'),
                            ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM animals WHERE name='Devimon'), '04-05-2021'),
                            ((SELECT id FROM vets WHERE name='Jack Harkness'), (SELECT id FROM animals WHERE name='Charmander'), '24-02-2021'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Plantmon'), '21-12-2019'),
                            ((SELECT id FROM vets WHERE name='William Tatcher'), (SELECT id FROM animals WHERE name='Plantmon'), '10-08-2020'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Plantmon'), '07-04-2021'),
                            ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM animals WHERE name='Squirtle'), '29-09-2019'),
                            ((SELECT id FROM vets WHERE name='Jack Harkness'), (SELECT id FROM animals WHERE name='Angemon'), '03-10-2020'),
                            ((SELECT id FROM vets WHERE name='Jack Harkness'), (SELECT id FROM animals WHERE name='Angemon'), '04-11-2020'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Boarmon'), '24-01-2019'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Boarmon'), '15-05-2019'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Boarmon'), '27-02-2020'),
                            ((SELECT id FROM vets WHERE name='Maisy Smith'), (SELECT id FROM animals WHERE name='Boarmon'), '03-08-2020'),
                            ((SELECT id FROM vets WHERE name='Stephanie Mendez'), (SELECT id FROM animals WHERE name='Blossom'), '24-05-2020'),
                            ((SELECT id FROM vets WHERE name='William Tatcher'), (SELECT id FROM animals WHERE name='Blossom'), '11-01-2021');