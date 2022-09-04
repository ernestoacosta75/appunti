# NOTAZIONE PREFISSA E POSTFISSA

**Notazione Prefissa (Prefix notation)**
L'incremento/decremento ha la priorità sugli altri operatori
```
--a;		++a;

int a = 10;
int b = 5 + ++a;

Console.WriteLine(a);	// 11
Console.WriteLine(b);	// 16
```

**Notazione Postfissa (Postfix notation)**
L'incremento/decremento accade dopo.
```
a--;		a++;

int a = 10;
int b = 5 + a++;

Console.WriteLine(a);	// 11
Console.WriteLine(b);	// 15
```

## Casting

**Implicit Casting** utiliza la "Widening Conversion" (Conversione di un tipo più "stretto" in un tipo più "largo")
```
int a = 10;
double d = 15.6 + a;
```

**Explicit Casting**
```
double d = 15.6;
int a = 5 + (int)d;

int a = 255;
byte b = (byte)a;	// b = 255
```

**OVERFLOW**
```
int a = 255;
byte b = (byte)a;	// b = 255	No problem

int a = 256;
byte b = (byte)a;	// b = 0	Overflow

int a = 260;
byte b = (byte)a;	// b = 4	Overflow
```
## La classe Convert

Appartiene al namespace **System.Convert**.

```
int a = 150;
string s = Convert.ToString(a);

Console.WriteLine(s);
```

Ci sono altri metodi della classe Convert:
```
Convert.ToBoolean(Int32);
Convert.ToChar(Int16);
Convert.ToDouble(String );
```