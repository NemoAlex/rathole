## Systemd Unit Examples

The directory lists some systemd unit files for example, which can be used to run `redhat` as a service on Linux.

[The `@` symbol in the name of unit files](https://superuser.com/questions/393423/the-symbol-and-systemctl-and-vsftpd) such as
`redhat@.service` facilitates the management of multiple instances of `redhat`.

For the naming of the example, `redhats` stands for `redhat --server`, and `redhatc` stands for `redhat --client`, `redhat` is just `redhat`.

For security, it is suggested to store configuration files with permission `600`, that is, only the owner can read the file, preventing arbitrary users on the system from accessing the secret tokens.

### With root privilege

Assuming that `redhat` is installed in `/usr/bin/redhat`, and the configuration file is in `/etc/redhat/app1.toml`, the following steps show how to run an instance of `redhat --server` with root.

1. Create a service file.

```bash
sudo cp redhats@.service /etc/systemd/system/
```

2. Create the configuration file `app1.toml`.

```bash
sudo mkdir -p /etc/redhat
# And create the configuration file named `app1.toml` inside /etc/redhat
```

3. Enable and start the service.

```bash
sudo systemctl daemon-reload # Make sure systemd find the new unit
sudo systemctl enable redhats@app1 --now
```

### Without root privilege

Assuming that `redhat` is installed in `~/.local/bin/redhat`, and the configuration file is in `~/.local/etc/redhat/app1.toml`, the following steps show how to run an instance of `redhat --server` without root.

1. Edit the example service file as...

```txt
# with root
# ExecStart=/usr/bin/redhat -s /etc/redhat/%i.toml
# without root
ExecStart=%h/.local/bin/redhat -s %h/.local/etc/redhat/%i.toml
```

2. Create a service file.

```bash
mkdir -p ~/.config/systemd/user
cp redhats@.service ~/.config/systemd/user/
```

3. Create the configuration file `app1.toml`.

```bash
mkdir -p ~/.local/etc/redhat
# And create the configuration file named `app1.toml` inside ~/.local/etc/redhat
```

4. Enable and start the service.

```bash
systemctl --user daemon-reload # Make sure systemd find the new unit
systemctl --user enable redhats@app1 --now
```

### Run multiple services

To run multiple services at once, simply add another configuration, say `app2.toml` under `/etc/redhat` (`~/.local/etc/redhat` for non-root), then run `sudo systemctl enable redhats@app2 --now` (`systemctl --user enable redhats@app2 --now` for non-root) to start an instance for that configuration.

The same applies to `redhatc@.service` for `redhat --client` and `redhat@.service` for `redhat`.
