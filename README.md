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

The first interactive shell of each calendar day fetches `origin/master` and
compares the GitHub commit, the local repository, and installed managed files.
It stays quiet when everything matches and suggests `shell-scripts-update`,
`shell-scripts-push`, or a merge when the corresponding side has changes. Run
`shell-scripts-check-daily --force` for an immediate check, or set
`SHELL_SCRIPTS_DAILY_CHECK=0` to disable the automatic check.

`shell-scripts-diff` includes installed-file differences. If a managed file was
edited in place (for example `~/bin/prj`), run
`shell-scripts-capture-installed` before publishing it with
`shell-scripts-push`.

The consolidation intentionally excludes machine binaries and generated or
vendor artifacts found in `~/bin`: ELF executables, Android platform-tools,
archives, Python bytecode, AppleDouble metadata and broken absolute symlinks.
The separately maintained third-party scripts `repo`, `git-when-merged` and
`nvmaint.pl` are also excluded; install them from their upstream projects.
