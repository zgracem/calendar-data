# `~/.calendar`

This repository contains custom data files for [BSD's `calendar` utility][cal],
created (and/or edited) and maintained by me.

[cal]: https://packages.debian.org/stable/calendar

## Installation

```sh
brew install zgracem/formulae/zgm-calendar-data
```

This command will execute the following:

1. Tap [my personal repo](https://github.com/zgracem/homebrew-formulae) of
   custom Homebrew formulae.
2. Install, as a prerequisite, [the latest version of `calendar`][bin], with
   its default data files in `/usr/local/opt/calendar/share/calendar`.
3. Install [the files from this repository][dat] to `/usr/local/share/calendar`.

[bin]: https://github.com/zgracem/homebrew-formulae/blob/main/Formula/calendar.rb
[dat]: https://github.com/zgracem/homebrew-formulae/blob/main/Formula/zgm-calendar-data.rb

## Usage

1. Create a personal calendar file at `~/.calendar/calendar`, e.g.:

    ```cpp
    // relative to /usr/local/share/calendar
    #include <calendar.canada>
    #include <calendar.space>
    #include <calendar.women>
    #include <calendar.zbirthday>
    #include <calendar.zholiday>

    // relative to /usr/local/opt/calendar/share/calendar
    #include <calendar.computer>
    #include <calendar.history>
    #include <calendar.judaic>
    ```

2. Add `/usr/local/opt/calendar/bin` to your `PATH`.

3. Run `calendar` from your favourite shell.

## Links

* [FreeBSD man page for `calendar(1)`](https://man.freebsd.org/cgi/man.cgi?query=calendar&sektion=1)
* [FreeBSD calendar data files](https://github.com/freebsd/calendar-data)
* [OpenBSD man page for `calendar(1)`](https://man.openbsd.org/calendar.1)
* [OpenBSD calendar data files](https://github.com/openbsd/src/tree/master/usr.bin/calendar/calendars)
* [Debian calendar data files](https://salsa.debian.org/meskes/bsdmainutils/-/tree/master/debian/calendars)
* [macOS man page for `calendar(1)`](https://ss64.com/osx/calendar.html) — last updated in 2002
