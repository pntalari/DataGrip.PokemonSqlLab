#PART 2: Simple Selects and Counts
# What are all the types of pokemon that a pokemon can have?
select name as Name
from types;

# What is the name of the pokemon with id 45?
select name
from pokemon.pokemons
where id = 45;

# How many pokemon are there?
select count(*)
from pokemon.pokemons;

# How many types are there?
select COUNT(*)
from pokemon.types;

# How many pokemon have a secondary type?
select count(*)
from pokemons
where secondary_type is not null;

# PART 3: Joins and Groups
# What is each pokemon's primary type?
select p.name as Pokemon_Name, t.name as Primary_Type
from pokemons p,
     types t
where p.primary_type = t.id;

# What is Rufflet's secondary type?
select p.name as Pokemon_Name, t.name as Secondary_Type
from pokemons p,
     types t
where p.name = "Rufflet"
  and p.secondary_type = t.id;

# What are the names of the pokemon that belong to the trainer with trainerID 303?
select p.name
from pokemon_trainer tr,
     pokemons p
where trainerID = 303
  and tr.pokemon_id = p.id;

# How many pokemon have a secondary type Poison
select count(*)
from pokemons p,
     types ty
where ty.name = "Poison"
  and p.secondary_type = ty.id;

# What are all the primary types and how many pokemon have that type?
select distinct p.primary_type, count(p.name) pokemon_count
from types ty,
     pokemons p
where ty.id = p.primary_type
group by p.primary_type;

# How many pokemon at level 100 does each trainer with at least one level 100 pokemone have?
# (Hint: your query should not display a trainer
select p.name, p.id, count(1) cnt
from pokemon_trainer t,
     pokemons p
where t.pokemon_id = p.id
  and pokelevel = 100
group by p.name, p.id;


# How many pokemon only belong to one trainer and no other?
select p.name, count(1)
from pokemon_trainer ptr,
     trainers tr,
     pokemons p
where ptr.trainerID = tr.trainerID
  and p.id = ptr.pokemon_id
group by p.name
having count(1) = 1;

# PART 4: Final Report
# Display Pokemon Name, Trainer Name,	Level,	Primary Type,	Secondary Type
# Sort the data by finding out which trainer has the strongest pokemon so that this will act as a ranking of strongest to weakest trainer.
# You may interpret strongest in whatever way you want, but you will have to explain your decision.

# Ranking explanation: The trainers are ranked based on the sum of points from attack,defense,hp,maxhp,spatk,spdef,speed attributes from Pokemon_Trainer table.
select p.name                                                                       as Pokemon_Name,
       tr.trainername                                                               as Trainer_Name,
       pt.pokelevel                                                                 as Current_Level,
       (pt.attack + pt.defense + pt.hp + pt.maxhp + pt.spatk + pt.spdef + pt.speed) as Trainer_Ranking,
       max(case when t.id = p.primary_type then t.name else null end)               as Primary_Type,
       max(case when t.id = p.secondary_type then t.name else null end)             as Secondary_Type
       #   dense_rank() over (partition by p.name order by pokelevel desc ) rnk
from pokemons p,
     types t,
     trainers tr,
     pokemon_trainer pt
where t.id in (p.primary_type, p.secondary_type)
  and p.id = pt.pokemon_id
  and pt.trainerID = tr.trainerID
group by p.name, p.id, tr.trainername, pt.pokelevel, tr.trainerID, Trainer_Ranking
order by Trainer_Ranking desc;