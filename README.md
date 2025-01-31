# ymd
Print current timestamp in YYYYMMDD or YYYYMMDDHHMMSS format.\
\
Useful for batch files, when you need a variable with a timestamp, but do not want to parse regionally-dependent DATE environment variable.\
\
Actually, this is an experiment on downshifting - building a tiny executable with minimal resources, i.e. terse and dense code, no C runtime and no external libraries, no division and no multiplication, simplistic or functional DOS stub etc.\
This is a just for fun project, you should not be writing code like this in earnest.\
\
**Building**\
OpenWatcom C compiler is required.\
\
Standard build, application will work both in DOS and Win32:
```
wmake
```
Minimal build, application will work only in Win32:
```
wmake BASICSTUB=
```
