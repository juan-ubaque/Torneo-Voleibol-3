# Configuración de Sharding en MongoDB
# 1. Crear directorios para los shards
# Debemos configurar varios shards, cada uno con su propio conjunto de réplicas. Crea directorios para almacenar los datos de cada shard y el config server:

md c:\mongodb\shards\shard1
md c:\mongodb\shards\shard2
md c:\mongodb\shards\shard3
md c:\mongodb\config\config1
md c:\mongodb\config\config2
md c:\mongodb\config\config3
md c:\mongodb\mongos


# 2. Configurar los shards con replicación
# Cada shard será un conjunto de réplicas. Usa los siguientes comandos para iniciar los nodos:

    # Shard 1:
    start mongod --bind_ip localhost --port 27011 --dbpath c:\mongodb\shards\shard1 --replSet shard1 --shardsvr
    start mongod --bind_ip localhost --port 27012 --dbpath c:\mongodb\shards\shard1 --replSet shard1 --shardsvr
    start mongod --bind_ip localhost --port 27013 --dbpath c:\mongodb\shards\shard1 --replSet shard1 --shardsvr


    # Shard 2:
    start mongod --bind_ip localhost --port 27021 --dbpath c:\mongodb\shards\shard2 --replSet shard2 --shardsvr
    start mongod --bind_ip localhost --port 27022 --dbpath c:\mongodb\shards\shard2 --replSet shard2 --shardsvr
    start mongod --bind_ip localhost --port 27023 --dbpath c:\mongodb\shards\shard2 --replSet shard2 --shardsvr

    # Shard 3:
    start mongod --bind_ip localhost --port 27031 --dbpath c:\mongodb\shards\shard3 --replSet shard3 --shardsvr
    start mongod --bind_ip localhost --port 27032 --dbpath c:\mongodb\shards\shard3 --replSet shard3 --shardsvr
    start mongod --bind_ip localhost --port 27033 --dbpath c:\mongodb\shards\shard3 --replSet shard3 --shardsvr


# 3. Configurar los config servers
# Los config servers mantienen el estado del clúster y las rutas de los datos. Inicia los config servers como un conjunto de réplicas:

    start mongod --bind_ip localhost --port 27041 --dbpath c:\mongodb\config\config1 --replSet configReplSet --configsvr
    start mongod --bind_ip localhost --port 27042 --dbpath c:\mongodb\config\config2 --replSet configReplSet --configsvr
    start mongod --bind_ip localhost --port 27043 --dbpath c:\mongodb\config\config3 --replSet configReplSet --configsvr

# 4. Iniciar las configuraciones de replicación
# Conéctate a cada conjunto de réplicas y configúralos:
    # Config servers:
        mongosh --port 27041
        rs.initiate({
            _id: "configReplSet",
            configsvr: true,
            members: [
                { _id: 0, host: "localhost:27041" },
                { _id: 1, host: "localhost:27042" },
                { _id: 2, host: "localhost:27043" }
            ]
        })

# Shard 1:
    mongosh --port 27011
    rs.initiate({
        _id: "shard1",
        members: [
            { _id: 0, host: "localhost:27011" },  
        ]
    })
    rs.add("localhost:27012"); // Nodo secundario
    rs.add("localhost:27013"); // Nodo secundario


# Shard 2:

    mongosh --port 27021
    rs.initiate({
        _id: "shard2",
        members: [
            { _id: 0, host: "localhost:27021" },
        ]
    })
    rs.add("localhost:27022"); // Nodo secundario
    rs.add("localhost:27023"); // Nodo secundario

# Shard 3:
    mongosh --port 27031
    rs.initiate({
        _id: "shard3",
        members: [
            { _id: 0, host: "localhost:27031" },
        ]
    })
    rs.add("localhost:27032"); // Nodo secundario
    rs.add("localhost:27033"); // Nodo secundario

# 5. Iniciar el mongos router
# El mongos se utiliza como punto de entrada al clúster. Inicia el mongos y conéctalo a los config servers:
    start mongos --configdb configReplSet/localhost:27041,localhost:27042,localhost:27043 --bind_ip localhost --port 27050


# 6. Configurar el Sharding
# Conéctate al mongos para configurar los shards:

    mongosh --port 27050

    #Agregar shards al clúster
    sh.addShard("shard1/localhost:27011,localhost:27012,localhost:27013");
    sh.addShard("shard2/localhost:27021,localhost:27022,localhost:27023");
    sh.addShard("shard3/localhost:27031,localhost:27032,localhost:27033");


# 7. Habilitar sharding para la base de datos
# Habilita el sharding para la base de datos evento_deportivo:

    sh.enableSharding("evento_deportivo");
# 8. Configurar las colecciones para el sharding
# Especifica las claves de partición para cada colección:

# Colección equipos
sh.shardCollection("evento_deportivo.equipos", { "nombre": 1 });

# Colección árbitros
sh.shardCollection("evento_deportivo.arbitros", { "documento": 1 });

# Colección encuentros
sh.shardCollection("evento_deportivo.encuentros", { "fecha": 1, "lugar": 1 });

# Colección resultados
sh.shardCollection("evento_deportivo.resultados", { "encuentro_id": 1 });

# Colección tabla_posiciones
sh.shardCollection("evento_deportivo.tabla_posiciones", { "equipo_id": 1 });

# 9. Verificar la configuración
# Ejecuta el siguiente comando para verificar el estado del sharding:

sh.status();
# Pruebas
# Insertar datos y observar la distribución: Inserta datos en las colecciones y verifica cómo se distribuyen entre los shards.

# Simular cargas de trabajo: Ejecuta consultas para verificar el rendimiento y asegurarte de que las operaciones están optimizadas.