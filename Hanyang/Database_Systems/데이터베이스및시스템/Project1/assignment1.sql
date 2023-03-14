select name from pokemon where type = 'Grass' order by name asc;
select name from trainer where hometown = 'Brown City' or hometown = 'Rainbow City' order by name asc;
select distinct type from pokemon order by type asc;
select name from city where name like 'B%' order by name asc;
select hometown from trainer where name not like 'M%' order by hometown asc;
select nickname from catchedpokemon where level =(select max(level) from catchedpokemon) order by nickname asc;
select name from pokemon where name like 'a%' or name like 'e%' or name like 'i%' or name like 'o%' or name like 'u%' order by name asc;
select avg(level) as 'Average Level' from catchedpokemon;
select max(level) as 'MAX(level)' from catchedpokemon where owner_id = (select id from Trainer where name = 'Yellow');
select hometown from trainer group by hometown order by hometown asc;
select name, nickname from trainer, catchedpokemon where catchedpokemon.nickname like 'A%' and catchedpokemon.owner_id = trainer.id order by name asc;
select name from trainer where id = (select leader_id from gym where city = (select name from city where description = 'Amazon'));
with Fire as (select owner_id as ID, count(pid) as num from catchedpokemon where pid = some(select id from pokemon where type = 'Fire') group by owner_id) select ID, num as countFire from Fire where num = (select max(num) from Fire);
select distinct type from pokemon where id < 10 order by id desc;
select count(id) as count from pokemon where type <> 'Fire';
select name from pokemon where id = (select before_id from evolution where before_id > after_id);
with Water as (select level from catchedpokemon where pid = some (select id from pokemon where type = 'Water')) select avg(level) as avgLevel from Water;
with Leader as (select nickname, level from catchedpokemon where owner_id = some (select leader_id from gym)) select nickname from Leader where level = (select max(level) from Leader);
with Blue as (select owner_id, level from catchedpokemon where owner_id = some (select id from trainer where hometown = 'Blue City')), avgBlue as (select owner_id, avg(level) as avglevel from Blue group by owner_id) select name from trainer where id = (select owner_id from avgBlue where avglevel = (select max(avglevel) from avgBlue)); 
with evolpok as (select owner_id, pid from catchedpokemon where pid = some(select before_id from evolution)), Elect as (select owner_id, pid from evolpok where pid = some(select id from pokemon where type = 'electric')), homedup as (select id, count(hometown) as num from trainer where id = some(select owner_id from Elect) group by hometown) select name from pokemon where id = some(select pid from Elect where owner_id = some(select id from homedup where num=1));
with sumLevel as (select owner_id, sum(level) as sumLevel, id from catchedpokemon where owner_id = some(select leader_id from gym) group by owner_id) select trainer.name as leader, sumLevel.sumLevel from trainer left join sumLevel on trainer.id = sumLevel.owner_id where not sumLevel is null order by sumLevel desc;
with homecount as (select hometown, count(hometown) as num from trainer group by hometown) select hometown from homecount where num = (select max(num) from homecount);
with sangnok as (select owner_id, pid from catchedpokemon where owner_id = some(select id from trainer where hometown = 'Sangnok city')), brown as (select owner_id, pid from catchedpokemon where owner_id = some(select id from trainer where hometown = 'Brown City')) select name from pokemon where id = some (select pid from sangnok where pid = some(select pid from brown)) group by name order by name asc; 
with Ppokemon as (select owner_id from catchedpokemon where pid = some(select id from pokemon where name like 'P%')) select name from trainer where id = some(select owner_id from Ppokemon) and hometown = 'Sangnok City' order by name asc; 
with catchname as (select trainer.name as tname, catchedpokemon.pid as cpid from trainer left join catchedpokemon on trainer.id = catchedpokemon.owner_id) select catchname.tname as TrainerName, pokemon.name as PokemonName from catchname left join pokemon on catchname.cpid = pokemon.id order by TrainerName asc, PokemonName asc; 
with first_evol as (select before_id as first_id from evolution where after_id = some(select after_id as second_id from evolution where after_id = some(select before_id from evolution))), second_evol as (select after_id as second_id from evolution where after_id = some(select before_id from evolution)) select name from pokemon where id = some(select before_id from evolution where before_id not in (select first_id from first_evol) and before_id not in (select second_id from second_evol)) order by name asc; 
with sangnok as (select pid from catchedpokemon where owner_id = some(select leader_id from gym where city = 'Sangnok City')) select nickname from catchedpokemon where pid = some(select id from pokemon where type = 'water' and id = some (select pid from sangnok)) order by nickname asc;
with evolved as (select owner_id, count(pid) as num from catchedpokemon where pid = some(select after_id from evolution) group by owner_id) select name from trainer where id = some(select owner_id from evolved where num >= 3) order by name asc; 
select name from pokemon where id not in (select pid from catchedpokemon group by pid) order by name asc; 
with homelevel as (select trainer.hometown as hometown, catchedpokemon.owner_id, catchedpokemon.level as level from trainer right join catchedpokemon on trainer.id = catchedpokemon.owner_id) select max(level) as maxLevel from homelevel group by hometown order by maxLevel desc;
with evol_step as (select f.before_id as first, f.after_id as second , s.after_id as third from evolution as f right join evolution as s on f.after_id = s.before_id where not f.before_id is null) select e.first as id, f.name as firstName, s.name as secondName, t.name as thirdName from evol_step as e right join pokemon as f on e.first = f.id right join pokemon as s on e.second = s.id right join pokemon as t on e.third = t.id where not e.first is null order by e.first asc;




 

