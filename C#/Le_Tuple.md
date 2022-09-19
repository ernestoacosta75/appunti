# Introduzione

Le **tuple** sono un sistema per rappresentare un insieme di dati eterogenei in modo molto semplice e diretto.

Uno dei motivi principali per l'utilizzo delle tuple è il fatto che consentono di ritornare dei valori multipli da un metodo, senza bisogno di ricorrere ai parametri **out**.

Le tuple possono essere subdivise in due grande famiglie:

**TUPLE LITERAL**

* **Tuple senza nome (unnamed)**
In una tupla unnamed, ogni singolo elemento riceve un nome standard **Item<progressivo>** dove il progressivo è un contatore che parte da 1 fino a 8.

```
var myColor = (255, 191, 0, "ambra");

Console.WriteLine(myColor.Item1);   // 255
Console.WriteLine(myColor.Item4);   // ambra
```

* **Tuple con nome (named)**
In una named tupla, il nome di ciascun elemento è un identificatore che viene seguito dal carattere **:** , seguito dal valore.

```
var myColor = (
    red: 255,
    green: 191,
    blue: 0,
    name: "ambra"
);

Console.WriteLine(myColor.red);   // 255
Console.WriteLine(myColor.name);   // ambra
```

# Tuple Projection Initializers (a partire della version 7.1 di C#)

Si possono **proiettare** delle variabili in una tupla, andandone a crearne una che contiene queste variabili con i loro varabiali, e dove ogni elemento andrà a ricevere il nome della variabile.

```
int red = 255;
int green = 191;
int blue = 0;
string name = "ambra";

var myColor = (red, green, blue, name); // Inizzializazione per proiettione di una tupla

Console.WriteLine(myColor.red);   // 255
Console.WriteLine(myColor.name);   // ambra
```

# Tuples in Action (TuplesInAction.csproj)

