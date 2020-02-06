
# soSsh:
Group based ssh connection script!

## Features
All features are configurable per server. If not provided, `default` is used.
 - Custom ssh port
 - [RemoteSubl](https://github.com/randy3k/RemoteSubl)
 - Dynamic server list (Manger1, Manger2, Manger3, ...)

Coming soon
 - GPG Keys

Overview
| Field | Required | Default |      -      |
|:-----:|:--------:|:-------:|:-----------:|
|   id  |     ✓    |   null  |  Select id  |
|   ip  |     ✓    |   null  |             |
|  name |     ✓    |    -    | Server name |
|  rsub |     ☓    |  false  |             |

## Usage
### Config file
`soSsh` looks for a file named `.sossh` in the user's home directory.
If no config is found, `soSsh` creates and empty file and exits

### Config objects
#### Default
Set default fallback value for value's. If a
```
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
                    "id": 1,
                    "name": "Plex",
                    "s": [
                        {
                            "id": 0,
                            "name": "Plex",
                            "ip": "myplexserver.com",
                        },
                        {
                            "id": 1,
                            "name": "Gitlab",
                            "ip": "mygitlab.com"
                        },
                        {
                            "id": 2,
                            "name": "Storage",
                            "ip": "8.8.8.8",
                            "rsub": "52698"
                        }
                    ]
                },
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
