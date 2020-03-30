# minimal-watcher

This minimal watcher saves a copy of an url every times it changes, with adjustable ping interval. It's written in pure bash (uses curl for web requests) and is easily hackable.

## Configuration

Create a file named `watchlist` (you can change this filename in the script directly) with one url to watch on each line, with the following format:

```
<nickname>,<interval>,<url>
```

Notice the lack of spaces. `nickname` should be a word identifying the url. It should not be a prefix of an other nickname. `interval` is the ping interval in seconds, and `url` is the url to ping.

Here is the config file this watcher was created for:
```
centrale,5,https://www.concours-centrale-supelec.fr/
mines,5,https://www.concoursminesponts.fr/
scei,5,http://www.scei-concours.fr/
```

## Generated files

Every time a new version is detected, the watcher outputs a line similar to this
```
[HH:MM:ss] new version <nickname>
```
and a new file is saved in the `results` directory named `<nickname>-<epoch>.html`

## New version hook

You can fill in the `newhook.sh` script with commands you'd like to run when a new version is detected. The first (and only) argument given to the script will be the changed url's `nickname`
