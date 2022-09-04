** Comando per creare un'applicazione di tipo console**

dotnet new console -o <namespace>

Ex.: dotnet new console -o inizio

# Gli Integral Types

## IL TIPO INT

**int** 32 bit signed
```
int x = 10;
int y = -120;
```
Le varianti per i numeri interi sono:

**byte**  8 bit, unsigned
**short** 16 bit, signed
**long**  64 bit, signed

Altri tipi di int sono:

**sbyte**  8 bit, signed
**ushort** 16 bit, unsigned
**uint**   32 bit, unsigned
**ulong**  64 bit, unsigned

**LITERAL BINARIO**
```
int x = 0b11010110; --> 214
```

**LITERAL ESADECIMALE**
```
int x = 0x1F5B; --> 8027
```

**SEPARATORE DI CIFRE**(C#7.0)
```
int x = 143_564_834; --> 143564834
```

**IL TIPO CHAR**

**char** 16 bit, unsigned
```
char c = 'A';
```