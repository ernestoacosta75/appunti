# Introduzione alle Struct
Le **Struct** sono un nuovo modo di creare i nostri tipi di dati.
Sono dei tipi messi a disposizione dal linguaggio, pensate per contenere una certa organizzazione di dati, essatamente come possiamo fare con le classi, con alcuna differenze fondamentali.

**DEFINIZIONE DI UNA STRUCT**
```
public struct Person {
    private string name;
    public string Nome{ get; set; }
}

public class Person {
    private string name;
    public string Nome{ get; set; }
}
```

1. Le Struct sono value types. Le classi sono reference types.
   Una Struct mantiene dentro di se tutti i propri valori.

2. Le Struct non possono essere assegnate a **null**.
3. Le Struct non possono definire un proprio **costruttore senza parametri**.
4. Le Struct non supportano l'**ereditarietà**.

# Inizializzazione di una Struct

```
public struct Person {
    public string name;
    public string lastName;
}

Person person;
person.name = "Mario";
person.lastName = "Rossi";

Person person1 = new Person("Mario", "Rossi");
```

**Quando utilizare una classe e quando una Struct?**
Conviene definire una Struct quando abbiamo bisogno di aggregare fra loro una serie di dati omogenei dal punto di vista del significato, abbastanza semplici.

# I Built-In Types come Struct

**I Built-In Types sono delle Struct!**

I tipi predefiniti di C# sono degli alias per delle Struct che sono definite nel namespace System di .Net.
**NOTA:** String è una classe, non una Struct, quindi è un reference type, ma dimostra un comportamento simile a quello dei value type.

| Alias   Struct                |
| :---------------------------- |
| bool    System.Boolean        |
| byte    System.Byte           |
| sbyte   System.SByte          |
| char    System.Char           |
| decimal System.Decimal        |
| double  System.Double         |
| float   System.Float          |
| int     System.Int32          |
| uint    System.UInt32         |
| long    System.Int64          |
| ulong   System.UInt64         |
| short   System.Int16          |
| ushort  System.UInt16         |
| string  System.String (Class) |

**ALIAS**
```
int x = 10;
Int32 x = 10;

int x = new int();
int x = new Int32();
```