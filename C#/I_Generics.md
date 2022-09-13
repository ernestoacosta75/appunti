# Introduzione

In C# esistono:

* Tipi generici (class, struct, interface)
* Metodi generici

**Generics** significa che è possibile definire, sia per i tipi che per i metodi, dei **parametri di tipo**.
Un **parametro di tipo** è semplicemente un *segnaposto* che ci consente di rimandare al momento della creazione dei veri e propri oggetti oppure al momento dell'invocazione di uno specifico metodo, la scelta di quello che sarà il tipo essatto che sarà utilizzato.

# I metodi generici

**OVERLOAD DI METODI**

```
public class Printer {
    public void toPrint(int n) {
        Console.WriteLine(n);
    }

    public void toPrint(string s) {
        Console.WriteLine(s);
    }
}

...

static void Main(string[] args) {
    Printer printer = new Printer();
    printer.toPrint(12);
    printer.toPrint("Mario");
}
```

**METODO GENERICO**

* **<T>** : Indicazione al compilatore che si sta definendo un metodo generico.
            Il metodo, pertanto, avrà almeno uno dei propri parametri con le indicazioni di un tipo T.

**T** non è altro che un segnaposto per un tipo, ad indicare che al momento dell'invocazione del metodo, noi ci impegniamo a fornire un valore attuale per il parametro **v** di un qualche tipo.
Questo tipo sarà specificato di volta in volta. Non è predefinito.

```
public class Printer {
    public void toPrint<T>(T v) {
        Console.WriteLine(v);
    }
}
```

**INVOCAZIONE METODO GENERICO**

Un metodo generico si invoca specificando il tipo del parametro al momento di ciascuna invocazione.

```
static void Main(string[] args) {
    Printer printer = new Printer();
    printer.toPrint(12);
    printer.toPrint("Mario");
}
```

# Ancora sui metodi generici

Si può anche specificare un segnaposto come valori di ritorno del metodo:

```
public class Printer {
    public T toPrint<T>(T v) {
        Console.WriteLine(v);
        return v;
    }
}

...

static void Main(string[] args) {
    Printer printer = new Printer();
    int a = printer.toPrint(12);
    string b = printer.toPrint("Mario");
}
```

Si possono specificare più segnaposti per dei data type diferenti:

```
public class Printer {
    public void toPrint<S,T>(S e1, T e2) {
        Console.WriteLine($"{e1} {e2}");
    }
}

...

static void Main(string[] args) {
    Printer printer = new Printer();
    printer.toPrint<int, string>(12, "Mario");
    printer.toPrint<string, char>("Susanna", 'S');
}
```

**STESSO SEGNAPOSTO, PIÙ PARAMETRI**

```
public class Printer {
    public void toPrint<T>(T e1, T e2) {
        Console.WriteLine($"{e1} {e2}");
    }
}
```

**INVOCAZIONE CON PARAMETRI DELLO STESSO TIPO T**

```
static void Main(string[] args) {
    Printer printer = new Printer();
    printer.toPrint<string, string>("Mario", "Susanna");
    printer.toPrint<int>(12, 45);
}
```

# Definire una classe generica

**UNA LISTA DI INTERI**

```
public class IntList {
    private int[] aList;

    public IntList() {
        aList = new int[10];
    }

    public void Insert(int p_value, int p_position) {
        if (p_position < 10) {
           return aList[p_position];
        }
    }

    public int Value(int p_position) {
        if (p_position < 10) {
           return aList[p_position];
        } else {
            throw new Exception();
        }
    }
}
```

**UNA CLASSE GENERIC**

```
public class GenericList<T> {
    private T[] aList;

    public GenericList() {
        aList = new T[10];
    }

    public void Insert(T p_value, int p_position) {
        if (p_position < 10) {
           return aList[p_position];
        }
    }

    public T Value(int p_position) {
        if (p_position < 10) {
           return aList[p_position];
        } else {
            throw new Exception();
        }
    }
}
```

# Usare una classe generica

```
...

static void Main(string[] args) {
    GenericList<string> strList = new GenericList<string>();
    strList.Insert("Mario", 5);

    GenericList<int> intList = new GenericList<int>();
    intList.Insert(120, 3);

    Console.WriteLine(strList.Value(5));  // "Mario"
    Console.WriteLine(intList.Value(3));  // 120
}
```

# Valori predefiniti

Sono i valori che servono ad inizzializare correttamente i tipi generici.

Per farlo, C# mette a disposizione un operatore particolare che si chiama **default**. Questo operatore segue delle regole ben precise:
* *Reference Type T*, **default(T)** vale **null**
* *Valori numerici*, **default(T)** restituisce **0**
* *Valori struct*, **default(T)** inizzializa ogni membro con **null** o **0**

```
public class MyGenClass<T> {
    private T element;

    public MyGenClass() {
        element = default(T);
    }

    // ...
}
```

# I type constraint

I **type constraint** permettono di aggiungere dei vincoli ai tipi generici.
Questi vincoli sono delle regole che in qualche modo, riducono la liberta' che abbiamo nell'utilizzare un generic.

**LA KEYWORD where**

Deve essere specificate dopo il nome della classe generica:

```
class GenClass<T> where T: MyClass   // Questo tipo T dovra' correspondere alla classe MyClass o una sottoclasse di essa
```

Un tipo generico puo' avere piu' di un vincolo. In questo caso, i constraint dovranno essere separati tra di loro con una virgola.
I constraint che possono essere specificati sono i seguenti:

* where T: **struct**    // significa che l'argomento T deve essere un value type
```
class GenClass<T> where T: struct
```

* where T: **class**    // significa che l'argomento T deve essere un reference type
```
class GenClass<T> where T: class
```

* where T: **new()**    // significa che l'argomento T deve necessariamente possedere un costruttore pubblico e
                        // senza parametri (costruttore di default)
                        // dovrebbe essere l'ultimo constraint nel caso ci fossero altri
```
class GenClass<T> where T: new()
```

* where T: **nome della classe base**    // significa che l'argomento T deve essere una classe base o una sua
                                         // sottoclasse
```
class GenClass<T> where T: MyClass
```

* where T: **U**    // significa che l'argomento T deve corrispondere all'argomento fornito per U, oppure deve
                    // derivare dal tipo U
```
class GenClass<T,U> where T: U
```

# Interface generiche

Si possono definire delle interface che definiscono al suo interno dei metodi che contengono dei parametri di tipo.
Questi parametri di tipo possono essere usati come parametri per i metodi definiti nelle interface, oppure come valore di ritorno da questi metodi.

**UNA INTERFACE GENERICA**

```
public interface IMyInterface<T> {
    T MyMethod(T x);
}
```

**IMPLEMENTAZIONE DI UNA INTERFACE GENERICA**

```
public class MyClass<T> : IMyInterface<T> {
    public T MyMethod(T x) {
        return x;
    }
}

...

static void Main(string[] args) {
    MyClass<string> myClass = new MyClass<string>();
    Console.WriteLine(myClass.MyMethod("Mario"));
}
```

Si potrebbe anche creare una classe che non è generica, specificando un tipo concreto in sostituzione del parametro di tipo che è previsto nell'interface:

```
public class MyClass<string> : IMyInterface<string> {
    public string MyMethod(string x) {
        return x;
    }
}

...

static void Main(string[] args) {
    MyClass myClass = new MyClass();
    Console.WriteLine(myClass.MyMethod("Mario"));
}
```

# Struct generiche

```
struct MyStruct<T> where T : struct {
    public T a;
}

...

MyStruct<double> myStruct { 140.76 };
Console.WriteLine(myStruct.a);          // 140,76
```

# Nullable types

Una delle strutture generiche che ci viene messa a disposizione dal framework .NET, ci consente di introdurre all'interno dei nostri programmi, i tipi **Nullable**.

Per usare un nullable type, è sufficiente aggiungere un **?** dopo la specifica del tipo della variabile:

```
bool? myBool = true;
myBool = null;
```

Il **?** è una scorciatoia per **Nullable<T>**. Un Nullable type è un tipo che usa una struttura generica.
La struttura Nullable ha la proprietà **HasValue**, che consente di verificare se è presente o no un valore diverso da null all'interno di una variable di un Nullable type.

**LA STRUCT NULLABLE<T>**

```
Nullable<bool> myBool = true;
myBool = null;

if (myBool.HasValue) {
    Console.WriteLine("Valore presente");
}
```

Un'altra proprietà è **Value**, che riporta il valore che è associato alla variabile se la proprietà **HasValue** riporta un valore non null.

**VALUE**

```
Nullable<bool> myBool = true;
myBool = null;
bool b;

if (myBool.HasValue) {
    b = myBool.Value;
}
```

Esiste anche un operatore particolare che viene chiamato **null-coalescing operator**, che è rappresentato da **??**.
Esso ci consente di assegnare ad una variabile il valore effettivo di un Nullable type se questo è presente, oppure di assegnare un valore di riserva.

```
Nullable<bool> myBool = true;
myBool = null;

bool b = myBool ?? false;   // false
```