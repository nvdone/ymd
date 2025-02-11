# NVD YMD
# Copyright (C) 2025, Nikolay Dudkin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ASM = wasm
CC16 = wcc
CC32 = wcc386
LINKER = wlink

AFLAGS16 = -ms
CFLAGS32 = -I"$(%WATCOM)/h/nt" -bt=nt -s -ot -ob -ol -ol+ -oi -oa -or -oh -om -on -6r -oe2000
CFLAGS16 = -bt=dos -s -ot -ob -ol -ol+ -oi -oa -or -oh -om -on -zl -6 -oe2000
LFLAGS16 = sys dos op start=s
LFLAGS32 = sys nt op nor op start=m_

release : all cleaninterim .SYMBOLIC

all : ymd.exe ymdhms.exe ymd.cmd ymd.bat .SYMBOLIC

clean : cleaninterim cleanresult .SYMBOLIC

cleaninterim : .PROCEDURE
	del ymd_asm.obj ymd_dos.obj ymd_dos.exe ymd.obj ymdhms_dos.obj ymdhms_dos.exe ymdhms.obj 2>nul

cleanresult : .PROCEDURE
	del ymd.exe ymdhms.exe ymd.cmd ymd.bat 2>nul

!ifdef BASICSTUB
ymd_asm.obj : ymd.asm
	$(ASM) $(AFLAGS16) -DBASICSTUB -fo=$^. $[.

ymd_dos.exe : ymd_asm.obj
	$(LINKER) $(LFLAGS16) name $^. f { $? }
!else
ymd_asm.obj : ymd.asm
	$(ASM) $(AFLAGS16) -fo=$^. $[.

ymd_dos.obj : ymd.c
	$(CC16) $(CFLAGS16) -fo=$^. $[.

ymd_dos.exe : ymd_asm.obj ymd_dos.obj
	$(LINKER) $(LFLAGS16) name $^. f { $? }
!endif

ymd.obj : ymd.c
	$(CC32) $(CFLAGS32) -fo=$^. $[.

ymd.exe : ymd_dos.exe ymd.obj 
	$(LINKER) $(LFLAGS32) name $^. op stub=$[. f $].

!ifdef BASICSTUB
ymdhms_dos.exe : ymd_asm.obj
	$(LINKER) $(LFLAGS16) name $^. f { $? }
!else
ymdhms_dos.obj : ymd.c
	$(CC16) $(CFLAGS16) -dYMDHMS -fo=$^. $[.

ymdhms_dos.exe : ymd_asm.obj ymdhms_dos.obj
	$(LINKER) $(LFLAGS16) name $^. f { $? }
!endif

ymdhms.obj : ymd.c
	$(CC32) $(CFLAGS32) -dYMDHMS -fo=$^. $[.

ymdhms.exe : ymdhms_dos.exe ymdhms.obj 
	$(LINKER) $(LFLAGS32) name $^. op stub=$[. f $].

ymd.cmd : .PROCEDURE
	@%write $^@ @echo off
	@%append $^@ rem Windows
	@%append $^@ for /f %%s in ('ymd.exe') do (set YMD=%%s)
	@%append $^@ for /f %%s in ('ymdhms.exe') do (set YMDHMS=%%s)
	@%append $^@ echo %YMD%
	@%append $^@ echo %YMDHMS%

ymd.bat: .PROCEDURE
	@%write $^@ @echo off
	@%append $^@ rem FreeDOS
	@%append $^@ set /e YMD=ymd.exe
	@%append $^@ set /e YMDHMS=ymdhms.exe
	@%append $^@ echo %YMD%
	@%append $^@ echo %YMDHMS%
