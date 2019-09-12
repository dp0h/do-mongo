# do-mongo
Simple scripts for deploying MongoDB to DigitalOcean

See `make` for available targets.

## Configuration
Need to set DigitalOcean token (DO_ACCESS_TOKEN) to being able to create a Droplet.

Please place all private information outside of the repository, for example in .env file one level up (i.e. ../.env).

To keep MongoDB secure on DigitalOcean it'd be good to create/configure a Firewall to restrict access to MongoDB instance.
