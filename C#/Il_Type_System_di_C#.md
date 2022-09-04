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

**STRINGHE DI FORMATO**
```
int x = 10;
int y = 20;
Console.WriteLine("Primo = {0} Secondo = {1}", x, y); --> "Primo = 10 Secondo = 20"
```

**INTERPOLAZIONE DI STRINGHE DI FORMATO**
```
int x = 10;
int y = 20;
Console.WriteLine($"Primo = {x} Secondo = {y}"); --> "Primo = 10 Secondo = 20"
```

## Float, Double e Decimal Types

**IL TIPO FLOAT**
float 32 bit signed, 7 cifre di precizione
```
float myFloat = 12.5f;
```

**IL TIPO DOUBLE**
double 64 bit signed, circa 15 cifre di precizione
```
double myDouble = 20.5;
```

**IL TIPO DECIMAL** (viene usato per i calcoli di tipo finanziario)
decimal 128 bit signed, circa 28 cifre di precizione
```
decimal myDec = 90.17m;
```

**NOTAZIONE CIENTIFICA**

```
double x = 1.6e6; --> 1.6 * 10^6 ==> 1600000.0

double y = 1.4e-3; --> 1.4 * 10^-3 ==> 0.0014
```

## Bool e String

**IL TIPO BOOLEAN**
bool 8 bit
```
bool myBool = true;

bool yourBool = false;
```

**IL TIPO STRING** (è un reference type)
string
```
string s = "csharp";
```

## Type Inference

C# è in grado di inferire da solo i tipi dei dati primitivi sulla base della forma dei literal utilizzati quando le variabili vengono inizializzate.
Questo meccanismo si chiama **Inferenza di tipo**. è viene usata la keyword **var**.
```
var x = 10;
var myBool = true;
var myDouble = 5.75
var s = "Csharp";
```