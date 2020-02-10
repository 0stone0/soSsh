
# soSsh:
Group based ssh connection script!

## Setup
### Clone
```
git clone https://github.com/0stone0/soSsh.git /tmp/soSsh
```
### Make executable
```
sudo chmod +x /tmp/soSsh/soSsh
```
### Create config
Please see [example config](#example-config)
### Set global (Optionally)
```
sudo cp /tmp/soSsh/soSsh /usr/local/bin
```
or
```
sudo ln -s /tmp/soSsh/soSsh /usr/local/bin/
```
## Features
All features are configurable per server. If not provided, [default value](#default) is used.
 - Custom ssh port
 - [RemoteSubl](https://github.com/randy3k/RemoteSubl)
 - Dynamic server list (Manger1, Manger2, Manger3, ...)
 - [Quick Connect](#quick-connect). Add unique name to server, connect instant!

Coming soon
 - GPG Keys

## Usage
```
soSsh [-d] [-q QuickConnect]

    -d        Debug
    -q <qc>   QuickConnect
```
### Config file
`soSsh` looks for a file named `.sossh` in the user's home directory.

If no config is found, `soSsh` creates an empty file and exits

### Config objects
#### Default
Set default fallback value for connections. If default entry does not exists, the fallback described in overview will be used.
```
{
    "default": {
        "port": 1337,
        "user": "Juno"
    }
}
```

#### g (Group)
Use `g` to define a group, each group should contain a deeper group (`g`), or a server list (`s`).
```
{
    "g": [
        {
            "id": 1,
            "name": "My Group",
            "s": [
                {
                    "id": 1,
                    "name": "Server - 1",
                    "ip": "first.server.com"
                },
                {
                    "id": 2,
                    "user": 'root',
                    "name": "Storage",
                    "ip": "second.server.com"
                }
            ]
        ]
    }
}
```
#### s (Server)
| Field | Required | Fallback | Usage |
|:-----:|:--------:|:-------:|:-----------:|
|   id  |     ✓    |    -    |  Select id  |
|   ip  |     ✓    |    -    |  Server ip  |
|  name |     ✓    |    -    | Server name |
|  port |     ☓    |   22    | Server port |
|   qc  |     ☓    |    -    | [Quick Connect](#quick-connect) |
|  rsub |     ☓    |  false  | Port number |

```
{
    "id": 1,
    "name": "Awesome Server",
    "ip": "thisissoawesome.com"
}
```
##### Quick Connect
Add an unique identifyer to your server;
```
{
    "id": 8,
    "name": "FooServer",
    "ip": "1.2.3.4",
    "qc": "foo"
}
```

You can target the server without 'searching' for it by adding the `qc` to the command;
```
soSsh foo
```
##### Dynamic
Add an `t` field to the sever object descibing how many servers are available.
Add `??` to the server `name` and/or `ip`, this will be replaces `1` to `t`
```
{
    "id": 1,
    "name": "Manager - ??",
    "ip": "manager??.office.com",
    "t": 3
}
```
```
1) Manager -- 1 (manager1.office.com)
2) Manager -- 2 (manager2.office.com)
3) Manager -- 3 (manager3.office.com)
```

### Example config
`nano ~/.sossh`
```
{
    "default": {
        "port": 22,
        "user": "Juno",
        "rsub": false
    },
    "g": [
        {
            "id": 1,
            "name": "Private",
            "g": [
                {
                    "id": 0,
                    "name": "Plex",
                    "ip": "myplexserver.com",
                },
                {
                    "id": 1,
                    "name": "Gitlab",
                    "ip": "mygitlab.com",
                    "qc": git
                },
                {
                    "id": 2,
                    "name": "Storage",
                    "ip": "8.8.8.8",
                    "rsub": "52698"
                }
            ]
        },
        {
            "id": 2,
            "name": "Work",
            "s": [
                {
                    "id": 1,
                    "name": "Manager",
                    "ip": "manager??.office.com",
                    "t": 3
                },
                {
                    "id": 2,
                    "name": "LoadBalancer",
                    "ip": "??lb.office.com",
                    "t": 6
                }
            ]
        }
    ]
}
```
