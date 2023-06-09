*SETUP*
1. `bundle install` - install the gems
2. `Rails assets:precompile` - precompile bootstrap files
3. `docker-compose up --build` - build images and run the containers (not the app will listen under localhost:3000)
4. `docker exec -it contacts_app-web-1 /bin/bash` - accesss the running container
5. `bundle exec rails db:create db:migrate` - create and migrate the database

Application should now be ready to use under localhost:3000 !