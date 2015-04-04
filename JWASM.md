# Introduction #

JWasm is a free MASM-compatible assembler


# Features #

  * native support for output formats Intel OMF, MS Coff (32- and 64-bit), Elf (32-and 64-bit), Bin and DOS MZ.
  * precompiled JWasm binaries are available for DOS, Windows and Linux. For OS/2 and FreeBSD, makefiles are supplied.
  * Instructions up to SSE4.2 are supported.
  * JWasm is written in C. The source is portable and has successfully been tested with Open Watcom, MS VC, GCC and more.
  * As far as programming for Windows is concerned, JWasm can be used with both WinInc and Masm32. Since v2.01, it will also work with Sven B. Schreiber's ancient WALK32.
  * C header files can be converted to include files for JWasm with h2incX.
  * JWasm's source code is released under the Sybase Open Watcom Public License, which allows free commercial and non-commercial use.

# Compared to other assemblers #

## MASM ##

  * JWasm is free, no artificial license restrictions, can be used to create binaries for any OS.
  * JWasm is open source, forget the annoying MASM bugs ...
  * More output formats supported (Bin, ELF).
  * Optionally very small object modules can be created
  * Better support for Open Watcom, for example the register-based calling convention
  * JWasm is faster than Masm.

## TASM ##

  * JWasm is available. TASM isn't legally available. And LZASM, which is sort of a TASM clone, understands IDEAL mode only.
  * JWasm has full support for STRUCTs and UNIONs. TASM has severe limitations and bugs in this area.
  * JWasm supports virtually all MASM v6 features (PROTO, INVOKE, hll directives, ... ), most of which TASM won't understand.
  * JWasm supports instructions up to SSE4, TASM is behind.

## POASM ##

  * JWasm is open source
  * JWasm additionally supports output in OMF, ELF and binary format
  * JWasm supports 16-bit and segmented memory models. POASM understands FLAT only.
  * JWasm is compatible with MASM's implementation of macros. POASM isn't.
  * POASM lacks the ability to create a listing file.

## WASM ##

  * JWasm's macro capabilities are ways better than Wasm's.
  * JWasm fully supports Masm v6 syntax. In Wasm, most of the additions done in Masm v6 are missing.
  * Besides OMF, JWasm supports COFF, ELF and binary output formats.
  * JWasm supports 64-bit.


# History #

JWasm is a fork of Open Watcom's WASM v1.7a. The most remarkable features which have been implemented are: [List of changes from Wasm 1.7a to JWasm 1.7](http://www.japheth.de/JWasm/Wasm.html)

# Links #

[Official JWASM site](http://www.japheth.de/JWasm.html)