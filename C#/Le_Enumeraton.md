# Introduzione alle Enumeration

L'**Enumeration** sono anche loro un value type e permettono di specificare un numero predefinito di valori che possono essere usati nei programmi per renderli più sicuri e più leggibili.

**DEFINIZIONE DI UNA ENUM** (si usa la keyword **enum**)
```
using System;

namespace Enumerations {
    enum CardinalPoints { north, south, east, west };

    public class Program {
        static void Main(string[] args) {
            CardinalPoints direction = CardinalPoints.north;

            if(direction == CardinalPoints.north) {
                Console.WriteLine("North direction");
            }
        }
    }
}
```

# Valori per le Enumeration

Il compilatore dichiara ciascuno dei valori di una Enum come un numero intero, in maniera progressiva.

```
int cardinal = (int)CardinalPoints.west;    // 3
```

**MODIFICA DEL TYPE DEI VALORI**
Il tipo dei valori di una Enum si possono modificare, sempre che siano di tipo intero:
```
enum CardinalPoints: short { north, south, east, west };

int cardinal = (int)CardinalPoints.west;    // 3
```

**MODIFICA DEI VALORI DEGLI ELEMENTI**
```
enum CardinalPoints { north = 10, south = 20, east = 30, west = 40 };

int cardinal = (int)CardinalPoints.west;    // 40
```

**INCREMENTO AUTOMATICO**
Si possono definire solo alcuni dei valori degli elementi di una Enum. Al resto dei valori verrà assegnato un valore progressivo in maniera automatica:
```
enum CardinalPoints { north = 10, south = 20, east, west };

int cardinal = (int)CardinalPoints.west;    // 22
```

```
using System;

namespace Enumerations {
    enum CardinalPoints { north, south, east, west };

    public class Program {
        static void Main(string[] args) {
            CardinalPoints direction = CardinalPoints.north;

            if(direction == CardinalPoints.north) {
                Console.WriteLine("North direction");
            }
        }
    }
}
```