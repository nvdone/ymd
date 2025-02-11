// NVD YMD
// Copyright (C) 2025, Nikolay Dudkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifdef __NT__
	#include <windows.h>
#endif //__NT__

inline unsigned long m100(unsigned long n)
{
	return (n << 6) + (n << 5) + (n << 2);
}

inline unsigned long m10K(unsigned long n)
{
	return (n << 13) + (n << 10) + (n << 9) + (n << 8) + (n << 4);
}

inline void d10(unsigned long n, unsigned long *q, char *r)
{
	*q = (n >> 1) + (n >> 2);
	*q = *q + (*q >> 4);
	*q = *q + (*q >> 8);
	*q = *q + (*q >> 16);
	*q = *q >> 3;
	*r = n - ((*q << 3) + (*q << 1));
	*q = *q + (*r > 9);
	*r += *r > 9 ? 38 : 48;
}

inline void c(char *s, unsigned long n, unsigned long d)
{
	while (d10(n, &n, s + --d), d);
}

#ifdef YMDHMS

	#ifdef __NT__
		void m()
		{
			char s[14];
			SYSTEMTIME t;
			GetLocalTime(&t);
			c(s, m10K(t.wYear) + m100(t.wMonth) + t.wDay, 8);
			c(s + 8, m10K(t.wHour) + m100(t.wMinute) + t.wSecond, 6);
			WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), s, 14, (DWORD *)&t, NULL);
			ExitProcess(0);
		}
	#else
		void m()
		{
			char s[15];
			unsigned y;
			char m, d, hh, mn, sc;

			s[14] = 36;

			__asm
			{
				mov ah, 2ah;
				int 21h;
				mov y, cx;
				mov m, dh;
				mov d, dl;
				mov ah, 2ch;
				int 21h;
				mov hh, ch;
				mov mn, cl;
				mov sc, dh;
			}

			c(s, m10K(y) + m100(m) + d, 8);
			c(s + 8, m10K(hh) + m100(mn) + sc, 6);

			__asm
			{
				lea dx, s;
				mov ah, 9h;
				int 21h;
			}
		}
	#endif //__NT__

#else

	#ifdef __NT__
		void m()
		{
			char s[8];
			SYSTEMTIME t;
			GetLocalTime(&t);
			c(s, m10K(t.wYear) + m100(t.wMonth) + t.wDay, 8);
			WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), s, 8, (DWORD *)&t, NULL);
			ExitProcess(0);
		}
	#else
		void m()
		{
			char s[9];
			unsigned y;
			char m, d;

			s[8] = 36;

			__asm
			{
				mov ah, 2ah;
				int 21h;
				mov y, cx;
				mov m, dh;
				mov d, dl;
			}

			c(s, m10K(y) + m100(m) + d, 8);

			__asm
			{
				lea dx, s;
				mov ah, 9h;
				int 21h;
			}
		}
	#endif //__NT__

#endif //YMDHMS
