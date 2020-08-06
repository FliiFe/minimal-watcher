# minimal-watcher

This minimal watcher saves a copy of an url every times it changes, with adjustable ping interval. It's written in pure bash (uses curl for web requests) and is easily hackable.

## Configuration

Create a file named `watchlist` (you can change this filename in the script directly) with one url to watch on each line, with the following format:

```
<nickname>,<interval>,<url>[,<preprocessor>]
```

Notice the lack of spaces. `nickname` should be a word identifying the url. It should not be a prefix of an other nickname. `interval` is the ping interval in seconds, and `url` is the url to ping. The `<preprocessor>` option is optional, see the dedicated section below.

Here is the config file this watcher was created for:
```
centrale,5,https://www.concours-centrale-supelec.fr/,iconv -f iso-8859-1 -t utf8
mines,5,https://www.concoursminesponts.fr/,perl -pe 's/.rwcache=\d+//g'
scei,5,http://www.scei-concours.fr/
banques-ecoles,5,https://banques-ecoles.fr/
```

## Generated files

Every time a new version is detected, the watcher outputs a line similar to this
```
[HH:MM:ss] new version <nickname>
```
and a new file is saved in the `results` directory named `<nickname>-<epoch>.html`

## New version hook

You can fill in the `newhook.sh` script with commands you'd like to run when a new version is detected. The first (and only) argument given to the script will be the changed url's `nickname`

## Preprocessor

For each url, you can define a preprocessor which will modify the downloaded webpage to your liking (to change the encoding, remove data that might change but that you don't care about, ...). Here is an example of a preprocessor to change the encoding:

```sh
iconv -f iso-8859-1 -t utf8
```

with the corresponding line in the watchlist
```
centrale,5,https://www.concours-centrale-supelec.fr/,iconv -f iso-8859-1 -t utf8
```

## Insecure requests

In some cases, you may want to discard ssl errors when making requests (e.g. if you have no control over a badly configured website). In that case, precede the corresponding line in the config file with `!`. Requests for this hook will be made with curl's `-k (insecure)` option.

```
!centrale,5,https://www.concours-centrale-supelec.fr/,iconv -f iso-8859-1 -t utf8
```

## Quiet !

By default the watcher will be verbose, and output a line for each url after each request, which can result in quickly growing log files. The `-q` option will turn those logs off and keep the bare minimal: the initial few lines indicating the preprocessors, urls, nicknames and intervals, and the new version alerts.
