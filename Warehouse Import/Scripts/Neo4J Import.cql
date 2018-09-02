NEO4J DATA MODELING
(https://neo4j.com/developer/guide-importing-data-and-etl/#_developing_a_graph_model)

Neo4J Settings
    + dbms.directories.import=c:/Neo4J
    + dbms.memory.heap.initial_size=1G
    + dbms.memory.heap.max_size=10G

********************************************************************
CREACION DE NODOS
********************************************************************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///country.csv" AS row
CREATE (:Country {id: toInteger(row.id), name: row.name})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///city.csv" AS row
CREATE (:City {id: toInteger(row.id), name: row.name})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///date_dim.csv" AS row
CREATE (:Date {id: toInteger(row.id), day: toInteger(row.day), month: toInteger(row.month), year: toInteger(row.year), dayOfTheWeek: row.dayoftheweek, bimester: toInteger(row.bimester), trimester: toInteger(row.trimester), quarter: toInteger(row.quarter), semester: toInteger(row.semester)})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///artist_credit_dim.csv" AS row
CREATE (:ArtistCredit {id: toInteger(row.id), name: row.name, artistCount: toInteger(row.artist_count)})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///artist_dim.csv" AS row
CREATE (:Artist {id: toInteger(row.id), name: row.name, type: row.type, gender: row.gender})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_dim.csv" AS row
CREATE (:Event {id: toInteger(row.id), name: row.name, time: row.time, type: row.type, cancelled: (case row.cancelled when 'f' then false else true end)})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
CREATE (:EventFact {idEvent: toInteger(row.id_event), placeName: row.place_name})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_dim.csv" AS row
CREATE (:Release {id: toInteger(row.id), name: row.name, packaging: row.packaging, language: row.language, status: row.status})

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
CREATE (:ReleaseFact {idRelease: toInteger(row.id_release)})

CREATE (:Unknown {id: 1, name: "Unknown"})


********************************************************************
CREACION DE INDICES
********************************************************************
CREATE INDEX ON :Country(id);
CREATE INDEX ON :City(id);
CREATE INDEX ON :Date(id);
CREATE INDEX ON :ArtistCredit(id);
CREATE INDEX ON :Artist(id);
CREATE INDEX ON :Event(id);
CREATE INDEX ON :EventFact(idEvent);
CREATE INDEX ON :Release(id);
CREATE INDEX ON :ReleaseFact(idRelease);

********************************************************************
CREACION DE RELACIONES
********************************************************************

**************
ARTIST CREDIT
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///artist_credit_dim.csv" AS row
MATCH (artistCredit:ArtistCredit {id: toInteger(row.id)})
MATCH (artist:Artist {id: toInteger(row.id_artist)})
MERGE (artistCredit)-[:INCLUDES]->(artist)

**************
EVENT
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
MATCH (eventFact:EventFact {idEvent: toInteger(row.id_event)})
MATCH (event:Event {id: toInteger(row.id_event)})
MERGE (eventFact)-[:REFERS_TO]-(event);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
MATCH (eventFact:EventFact {idEvent: toInteger(row.id_event)})
MATCH (date:Date {id: toInteger(row.id_date)})
MERGE (eventFact)-[:HAPPENED_ON]->(date);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
MATCH (eventFact:EventFact {idEvent: toInteger(row.id_event)})
MATCH (artist:Artist {id: toInteger(row.id_artist)})
MERGE (eventFact)-[:PERFORMED_BY]->(artist);

**************
RELEASE
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
MATCH (releaseFact:ReleaseFact {idRelease: toInteger(row.id_release)})
MATCH (release:Release {id: toInteger(row.id_release)})
MERGE (releaseFact)-[:REFERS_TO]-(release);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
MATCH (releaseFact:ReleaseFact {idRelease: toInteger(row.id_release)})
MATCH (artistCredit:ArtistCredit {id: toInteger(row.id_artist_credit)})
MERGE (releaseFact)-[:RELEASED_BY]->(artistCredit);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
MATCH (releaseFact:ReleaseFact {idRelease: toInteger(row.id_release)})
MATCH (date:Date {id: toInteger(row.id_date)})
MERGE (releaseFact)-[:RELEASED_ON]->(date);


******************************
AREA
******************************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///city.csv" AS row
MATCH (city:City {id: toInteger(row.id)})
MATCH (country:Country {id: toInteger(row.id_country)})
MERGE (city)-[:IS_PART_OF]->(country);

***************
EVENT
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
MATCH (eventFact:EventFact {idEvent: toInteger(row.id_event)})
MATCH (area:Country {id: toInteger(row.id_area)}) 
MERGE (eventFact)-[:TOOK_PLACE_IN]->(area);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///event_fact.csv" AS row
MATCH (eventFact:EventFact {idEvent: toInteger(row.id_event)})
MATCH (area:City {id: toInteger(row.id_area)}) 
MERGE (eventFact)-[:TOOK_PLACE_IN]->(area);

***************
ARTIST
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///artist_dim.csv" AS row
MATCH (artist:Artist {id: toInteger(row.id)})
MATCH (area:Country {id: toInteger(row.area)}) 
MERGE (artist)-[:IS_FROM]->(area);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///artist_dim.csv" AS row
MATCH (artist:Artist {id: toInteger(row.id)})
MATCH (area:City {id: toInteger(row.area)}) 
MERGE (artist)-[:IS_FROM]->(area);

***************
RELEASE
***************
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
MATCH (releaseFact:ReleaseFact {idRelease: toInteger(row.id_release)})
MATCH (area:Country {id: toInteger(row.id_area)}) 
MERGE (releaseFact)-[:RELEASED_IN]->(area);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///release_fact.csv" AS row
MATCH (releaseFact:ReleaseFact {idRelease: toInteger(row.id_release)})
MATCH (area:City {id: toInteger(row.id_area)}) 
MERGE (releaseFact)-[:RELEASED_IN]->(area);

***************
UNKNOWN NODE
***************
MATCH (u:Date {id: 80000})
REMOVE u:Date
REMOVE u.dayOfTheWeek
SET u:Unknown
SET u.id = 1
SET u.name = 'Unknown'

MATCH (a:City) WHERE NOT (a)-[:IS_PART_OF]->()
MATCH (u:Unknown {id: 1})
MERGE (a)-[:IS_PART_OF]->(u);

MATCH (a:EventFact) WHERE NOT (a)-[:TOOK_PLACE_IN]->()
MATCH (u:Unknown {id: 1})
MERGE (a)-[:TOOK_PLACE_IN]->(u);

MATCH (a:Artist) WHERE NOT (a)-[:IS_FROM]->()
MATCH (u:Unknown {id: 1})
MERGE (a)-[:IS_FROM]->(u);

MATCH (a:ReleaseFact) WHERE NOT (a)-[:RELEASED_IN]->()
MATCH (u:Unknown {id: 1})
MERGE (a)-[:RELEASED_IN]->(u);

