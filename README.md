# Movie Rama

Movie Rama is a Ruby on Rails application designed to manage and display movie information.
These are the key features of the application:
- Users​ are ​able​ ​to​ ​log​ ​into​ ​their​ ​account​ ​or​ ​sign​ ​up​ ​for​ ​a​ ​new​ ​one
- Users​ are ​able​ ​to​ ​add​ ​movies​ ​by​ ​completing​ ​a​ ​form.​ ​Movies​ are
persisted​ ​and​ ​reference​ ​the​ ​user​ ​that​ ​submitted​ ​them.
- Users​ ​should​ are ​to​ ​express​ ​their​ ​opinion​ ​for​ ​any​ ​movie​ ​by​ ​either​ ​a​ l​ike​​ ​or​ ​a​ ​hate​.
- Users​ ​can​ ​vote​ ​only​ ​once​ ​for​ ​each​ ​movie​ ​and​ ​can​ ​change​ ​their​ ​vote​ ​at​ ​any​ ​time​ ​by switching​ ​to​ ​the​ ​opposite​ ​vote​ ​or​ ​by​ ​retracting​ ​their​ ​vote​ ​altogether. This is done through POST, PATCH & DELETE requests.
- Users​ are ​not​ ​able​ ​to​ ​vote​ ​for​ ​the​ ​movies​ ​they​ ​have​ ​submitted. An error is reported in this case.
- Users​ are ​able​ ​to​ ​view​ ​the​ ​list​ ​of​ ​movies​ ​and​ ​sort​ ​them​ ​by​ ​number​ ​of​ l​ikes​, number​ ​of​ ​hates​​ ​or​ ​date​ ​added​.

### Ruby Version

3.4.2

### PostgreSQL

15.12

## Installation Instructions

### Docker compose

A running instance has been created for this project.

The steps for this type of installation are the following:

1. Follow the relevant instructions to install docker-compose: https://docs.docker.com/compose/install/
2. `sudo docker-compose build`
3. `docker-compose run --rm app rake db:create db:migrate db:seed`
4. `sudo docker-compose up`


**Notes**:

In case some of these do not work please bear in mind the following:

- You might need to stop postgres service locally: `sudo systemctl stop postgresql`
- Some docker compositions, containers and/or volumes might need to be removed:
  - `docker-compose rm`
  - Find running containers through `docker container ls -qa` and remove them by running
  `docker container rm [id]`
  - Find existing volumes through `docker volume ls` and remove them by running
  `docker volume [VolumeName]`

After completing these steps the app will be available for checks in browser through this
URL: http://127.0.0.1:3000/.

Random data have been inserted through `db:seed`.

Swagger documentation is also available through this URL:
http://localhost:3000/api-docs/index.html.

The coverage of this application is shown here:
http://0.0.0.0:8080

### Local Installation (Ubuntu)

Local installation has been tested in Ubuntu 24.04.2.

These are the steps followed:

1. Install RVM (https://rvm.io/)
2. Install Ruby version through RVM: `rvm install 3.4.2`
3. Install Rails: `gem install rails`
4. Install Redis: `sudo apt-get install redis-server`
5. Install PostgreSQL: `sudo apt-get install postgresql-15.12`
6. Connect to psql as postgres user: `sudo su postgres` then run
`psql` and create a superuser having the same username as
in your machine and grant all privileges: `GRANT ALL PRIVILEGES ON DATABASE "my_db" to my_user;`

For other operating systems, you can check the following:
- Rails: https://guides.rubyonrails.org/install_ruby_on_rails.html
- Postgres: https://www.postgresql.org/download/
- Redis: https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/install-redis-on-linux/

### Running the app after local installation

1. Go to the project folder
2. Run `bundle install`
3. Run `rails db:create db:migrate db:seed`
4. Run `rails s`

### Unit Tests

The application has been tested with RSpec. You can run the tests by executing the following command: `rspec`

All the lines of the codebase are covered by unit tests. You can see it by
running the testing suite and checking the `./coverage/index.html` file


## Important Features
### Swagger

Swagger documentation is used for better documenting the app's endpoints.
Both permitted parameters and the expected response can be displayed
by the out-of-the-box UI, helping different teams to be aware of
such information

### JSONAPI Serializers

This type of serializers are used in order for objects' serialization
to be more efficient. The serializations are actually cached and
updated every 5 minutes.

### JWT

JSON Web Tokens are used for user's authentication.
`has_secure_password` enables the app to effectively encrypt and
decrypt users' password making the app more secure.

### Query Efficiency

Scenic gem is used to make `aggregated_votes` a materialized view.
The information of 2 tables (`movies` and `votes`) are
gathered in this view in order
for the query that needs to run to display movies' table to be
efficient and scalable. Counting likes and hates per movie might
take a long time if it's runing every time this table needs to be loaded.

The movie table loading has the following characteristics:
- Pagination** is added to this table as an extra
feature to limit the rows shown and fetch or calculate additional information
(e.g., movie name, if it's liked by current user) only for the movies shown.
This way heavy table joins are avoided and such information are gathered only for a specific number of records.
- **Caching** is applied forming a key based on query's filters, sorting and
pagination selected.
- Likes and hates per movie are saved in a **materialized view**.
- This materialized view is refreshed using models' **callbacks**. Actually,
every time some movie is created or a vote is created, updated or deleted,
a job is triggered to asychronously update the records of `aggregated_votes` table.
**Note**: Based on this app's specifications, triggering a job seems preferable
when compared to schedules. It is attempted to update
`aggregated_votes` faster and almost immediately see the change of likes/hates
count.
- A check is added when performing the relevant table refresh job to avoid reperforming it
if it already exists because many users like and/or hate movies at the same time,
- Rails transactions are used when refreshing the materialized view to
ensure data integrity. The refresh should be completed to consider
that the whole `aggregated_votes` table is considered to have correct records

## Possibe TODOs
- Scan the codebase for security issues using `brakeman`
(https://github.com/presidentbeef/brakeman)
- Authorize requests cancanbased on users'
characteristics through `cancancan`
(https://github.com/CanCanCommunity/cancancan). For example,
this gem can help us requiring the user updating some movie's
title or description only if they are their creator.