
## AWK

#### Multiline
Do some multiline magic and bring those into one line.
```
cat multiline_file
--
  name ich
  info dumm
  platz 2

--
  name du
  info langsam
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
