## compression

```
bzip2 filename
```

### compress and save the original file
```
bzip2 -c filename > filename.bz2
```

## decompress
```
bzip2 -d -c filename.bz2 > filename
```

#### or
```
bunzip2 filename.bz2
```
