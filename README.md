# Simple plugin for remote clipboard sync
## How to use

1. clone the file both onto your local and remote machine
2. Change the is_server variable to true on your local copy and false on your remote copy
3. connect to a remote machine with the following command

```bash
ssh -R 2000:localhost:2000 <name@ipadresse> 
```

4. Open a nvim instance on your local machine and source the cloned file
5. Open a nvim instance on your remote machine and source the cloned file.

Now any text yanked on one machine will be immediatly availble in the "0 register of the other

## Disclaimer
This is a very simple lua script with many oversights, this was made as a first
attempt at learning the lua language and fixing an issue i have had syncing my
clipboards when working on remote servers.
I will hopefully improve upon it and package it more userfriendly in the future.
