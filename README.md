# distrobox-ubuntu-dev
An Ubuntu image for distrobox set up with dev tools


## How to use
Create new distrobox, pulling this container
```bash
distrobox create -i ghcr.io/jimjimovich/distrobox-ubuntu-dev -n ubuntu --pull
```

Enter the distrobox
```bash
distrobox enterubuntu
```

## Updating
```shell
distrobox-stop ubuntu --yes
distrobox-rm ubuntu --yes
distrobox create -i ghcr.io/jimjimovich/distrobox-ubuntu-dev -n ubuntu --pull
```

## Credits
Inspired by https://github.com/ublue-os/boxkit