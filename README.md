# backup.sh

simple backup script i made

might add more features in the future

depends on `jq`

**make sure to set** `backuppath` **at the top of the file**

reads directories from `config.json`, example config:

```json
[
	{
		"target": "/path/to/your/dir",
		"name": "name-of-archive"
	}
]
```
