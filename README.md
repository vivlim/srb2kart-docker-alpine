# srb2kart-docker-alpine

Docker container for running a Sonic Robo Blast 2 Kart dedicated server, from source on Alpine Linux.

This container builds [my patched sources](https://github.com/vivlim/Kart-Public) which make a couple tweaks to random level selection (namely, hell maps are disabled as well as kodachrome void).

## Usage

### Basic

`docker-compose up -d`

UDP port 5029 will be exposed.

### Advanced

#### Configuration

Create `config/kartserv.cfg` and add your configuration in the form of console commands there.

Documentation [here](https://wiki.srb2.org/wiki/Console/Variables).

To add extra command line arguments, for now the easiest way is to modify `srb2kart.sh` and put them in the script.

#### Addons

In order to load addons which have the .pk3 or .kart extensions, put them in the `/addons` directory and they will be copied into the assets folder during startup.

For addons which have more involved setup, this is currently an unsolved problem :)
