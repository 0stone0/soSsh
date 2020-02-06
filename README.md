
## soSsh:
Group based ssh connection script!

### Config
Config file: `~/.sossh`

example:
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