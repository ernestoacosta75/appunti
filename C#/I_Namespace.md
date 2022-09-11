I **namespace** è il meccanismo che viene utilizzato in C# per l'organizzazione dei nomi che noi le diamo all'entità, ai tipi che compongono i nostri programmi, allo scopo di evitare ambiguità e collisioni tra nomi.

* Un **namespace** è una collezione di nomi.
* All'interno di un namespace andremmo ad inserire dei tipi che dal punto di vista **funzionale** sono omegenei
  tra loro.
  Ex.: Un namespace potrebbe contenere un insieme di classi, di strutture, di interface che riguardano tutte insieme un certo **dominio applicativo**, come per esempio, la gestione dei clienti all'interno di un SW di gestione della contabilità.

**DEFINIZIONE DI UN NAMESPACE**

```
namespace First {
    class MyClass {
    }
}
```

**GERARCHIA DI NAMESPACE**

È possibile definire un namespace anche in forma gerarchicha, separando i nomi di ciascun livello della gerarchia con un punto (**.**):

```
namespace First.Second.Third {
    class MyClass {
    }
}
```

In alternativa a questa notazione, si potrebbe scrivere in questa maniera:

```
namespace First {
    namespace Second {
        namespace Third {
            class MyClass {
            }
        }
    }
}
```

**FULLY QUALIFIED NAME**

Possiamo riferirci ai tipi definiti all'interno di un namespace usando il nome qualificato completo:

```
First.Second.Third.MyClass
```

**GLOBAL NAMESPACE**

Un tipo che è definito al di fuori di qualunque namespace, oppure anche un namespace di primo livello, risiedono comunque in un namespace che viene detto **namespace globale**:

```
class AClass {
}

namespace First {
    class MyClass {
    }
}
```

# Importare un namespace

```
namespace First.Second.Third {
    class MyClass {
    }
}
```

All'interno di un programma si può accedere ai tipi definiti in un namespace con la keyword **using** (using <namespace_hierarchy>;):

```
using First.Second.Third;

class SecondClass {
    static void Main() {
        MyClass myObj;
    }
}
```

# Namespace ed alias

**COLLISIONE DI NOMI**

```
namespace NSFirst {
    public class MyClass {
    }
}

namespace NSSecond {
    public class MyClass {
    }
}

...

using NSFirst;
using NSSecond;

namespace Example {
    public class Program {
        static void Main(string[] args) {
            // AMBIGUITY!!
            MyClass myObj = new MyClass();
        }
    }
}
```
La soluzione sta nell'specificare in modo esplicito il namespace al quale appartiene la classe che si vuole usare:

```
NSFirst.MyClass myObj = new NSFirst.MyClass();
```

Il modo migliore, invece, è quello di usare gli **alias**, per dirle al compilatore all'interno di un sorgente di codice, in quale maniera vogliamo riferirci ad un specifico dato contenuto all'interno di uno specifico namespace:

**ALIAS**

```
namespace NSFirst {
    public class MyClass {
    }
}

namespace NSSecond {
    public class MyClass {
    }
}

...

using NSFirst;
using NSSecond;
using MyPClass = NSFirst.MyClass;   // using an alias

namespace Example {
    public class Program {
        static void Main(string[] args) {
            MyPClass myObj = new MyPClass();
        }
    }
}
```

# La direttiva 'using static'

**using static** ci permette di riferirci ai membri di una classe statica, senza indicare il nome della classe:

```
using System;

namespace Example {
    public class Program {
        static void Main(string[] args) {
            Console.WriteLine("CSharp");
        }
    }
}
```

Se al posto di **using System** usiamo **using static System.Console**, possiamo fare riferimento diretto ai metodi della class **Console**:

```
using static System.Console;

namespace Example {
    public class Program {
        static void Main(string[] args) {
            WriteLine("CSharp");
        }
    }
}
```