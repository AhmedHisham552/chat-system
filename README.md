##### Prerequisites

The setups steps expect following tools installed on the system.

- Docker
- docker-compose

### 1. Check out the repository

```bash
git clone git@github.com:AhmedHisham552/chat-system.git
```


### 2. Run the containerized application

Run the following commands to start the app along with the necessary containers

```bash
$ docker-compose up
```

### 3. To run the specs use

```bash
$ rspec spec
```

And now you can hit the endpoints with the URL http://localhost:3000

## Databases

Used mysql as the main datastore and a persisted redis database for id generation and sidekiq job queues


## Handling race conditions in id generation

As the id generation is handled by a redis datastore, the redis operation are atomic as redis is single threaded so it ensures that if any instances of the app is distributed on multiple servers there will be no race conditions. the redis db is persisted with an AOF such that if any outage occurs to the redis node, the system can recover and continue it's operation normally for id generation

## Job queues

Minimized writing to mysql directly by using ActiveJobs with sidekiq adapter in the endpoints that require creation, updating or deleting so that the app can keep serving requests while DB operations are done in the background

## Periodic tasks

Added synchronization of count columns as a cron job using whenever gem such that it gets updated every 45 minutes instead of incrementing the counts with every insertion as the columns are not needed to be live to reduce the amount of queries done against the DB.