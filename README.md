# ~/.calendar

This repository contains custom data files for [BSD's `calendar` utility][bsd].

[bsd]: https://packages.debian.org/stable/calendar

## Installation

Use [this custom Homebrew formula][cal] to install `calendar(1)` and its
default data files on macOS:

```sh
brew install zgracem/formulae/calendar
```

[cal]: https://github.com/zgracem/homebrew-formulae/blob/main/Formula/calendar.rb

Then (optionally) install my [custom calendar files]:

```sh
brew install zgracem/formulae/zgm-calendar-data
```

[custom calendar files]: https://github.com/zgracem/calendar-data

## Links

* [FreeBSD man page](https://man.freebsd.org/cgi/man.cgi?query=calendar&sektion=1)
* [FreeBSD data files](https://github.com/freebsd/calendar-data)
* [OpenBSD man page](https://man.openbsd.org/calendar.1)
* [OpenBSD data files](https://github.com/openbsd/src/tree/master/usr.bin/calendar/calendars)
