# Home shell scripts

Consolidated shell environment shared by macOS and Linux hosts.

Clone the repository from GitHub, then install it:

```sh
git clone git@github.com:dmitry-pervushin/home-shell-scripts.git
cd home-shell-scripts
./shell-scripts-install
```

- `bin/` contains commands and supporting source files.
- `prj` provides project/build helper functions.
- `project-vars` contains safe defaults overridden by project-local files.
- `vars/` contains optional project-specific variable sets.
- `hosts/` contains public host configuration.
- `hosts/private/` contains secrets and is ignored by Git.

Run `./shell-scripts-install` to copy the profile, commands and defaults into
the current home directory and link `~/hosts` to this checkout. `make install`
is still available and delegates to the same script.

After loading `prj`, run `shell-scripts-check` to verify the required command
line tools and report which optional tools used by common helpers are missing.
If `tput` or its terminfo database is unavailable, prompt colors fall back to
standard ANSI escape sequences.

The consolidation intentionally excludes machine binaries and generated or
vendor artifacts found in `~/bin`: ELF executables, Android platform-tools,
archives, Python bytecode, AppleDouble metadata and broken absolute symlinks.
The separately maintained third-party scripts `repo`, `git-when-merged` and
`nvmaint.pl` are also excluded; install them from their upstream projects.
