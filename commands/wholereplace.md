## for replacing all names inside the files
```
grep -rl "lastthing" . | xargs sed -i 's/lastthing/newthing/g'
```

## for renaming all file's names
```
find . -name '*kuma*' -type f | while read file; do
    mv "$file" "$(echo "$file" | sed 's/kuma/vista/g')"
done
```
## for renaming all dir names

```
find . -depth -name '*kuma*' -type d | while read dir; do
    mv "$dir" "$(echo "$dir" | sed 's/kuma/vista/g')"
done
```


