
## AWK

#### Multiline
Do some multiline magic and bring those into one line.
```
cat multiline_file
--
  name ich
  info langsam
  platz 2

--
  name du
  info schnell
  platz 1
```

```
awk '/--/{if (x)print x;x="";next}{x=(!x)?$0:x" "$0;}END{print x;}' multiline_file
```
Result:
```
name ich   info langsam   platz 2
name du   info schnell   platz 1
```

### gsub
#### Whitespaces and Tabs
Search and replace with gsub in awk
Text with tabs or two whitespaces, will be replaced by `;`
```
cat gsub_white_tab
hello this  is a  example
```
Use:
```
awk '{gsub("  |\t+",";");print }' gsub_white_tab
```
Result:
```
hello this;is a;example
```

#### File basename

get only filename and cat the path
```
echo "/opt/icinga/test/check_icinga" | awk '{gsub(/.*\//,"");print}'
check_icinga
```
Needed this when working on some CSV stuff
```
echo "/opt/icinga/test/check_test;somethingother;morestuff" | awk 'BEGIN{FS=";";OFS=FS}{base=$1;gsub(/.*\//,"",base);print base}'
```
Result:
```
check_test
```
#### Remove fields from row
```
row1;row2;row3;row4
```
Use:
```
echo "row1;row2;row3;row4" | awk -F ";" '{$2=$4=""; print}'
```
Result:
```
row1  row3
```

Can be done much easier if using cut
```
echo "row1;row2;row3;row4" | cut -d ";" -f-1,3
```
Result:
```
row1;row3
```
#### Remove whitespace from end of line
```
echo "whitespace at endline " |awk 'sub(/ *$/, "")'
```

## SED

#### Whitespace and Tabs
Search for two or more whitespaces and make them one space
```
cat whitespaces_tabs
Hallo World
This  is Text  with   tabs and  spaces
```
Use:
```
sed -e 's/[[:space:]]\{2,\}/\ /g' whitespaces_tabs
```
The syntax with `[[:space:]]` is for POSIX compatibility.

Result:
```
Hallo World
This is Text with tabs and spaces
```


#### more
