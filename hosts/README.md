# Host-specific secrets

Public, non-secret host configuration lives directly in this directory.
Shared secrets belong in `private/common`; host-specific overrides belong in
`private/<short-hostname>`. The entire private directory is ignored by Git.

For example:

```sh
export HASS_TOKEN="..."
```

`load-private` loads the shared file first and then the host-specific file.
