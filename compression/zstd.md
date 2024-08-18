#compression
```
zstd -19 filename
```

## to keep the original file
```
zstd -c filename > filename.zst
```

## decompress
## 1
#### Using the --decompress or -d Option:
```
zstd -d filename.zst
```

## decompress and save it to a file

```
zstd -d -c filename.zst -o filename
```
## 2
```
unzstd filename.zst
```


