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
