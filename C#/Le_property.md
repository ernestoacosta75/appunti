# Creare le Property

Visto che lo scrivere dei setter e getter per tutti gli attributi di una classe e' repetitivo, C# mette a disposizione **le Property**, che sono un modo piu' compatto e anche molto piu' elegante di gestire i metodi getter e setter. Queste Property vanno a sostituire le variabili d'istanza della classe.

Per implementare una Property:
1. Introdurre la definizione stessa:
```
public class Person {
    private string name;

    public string Name {
        // Al posto di getter, scriviamo la keyword "get" e ritorniamo il nome della variabile d'istanza
        // Potrebbe contenere anche della business logica applicativa
        get {
            return name;
        }

        // Al posto di setter, scriviamo la keyword "set" con un blocco di codice.
        // Il valore che viene assegnato alla variabile d'istanza si ottiene con la keyword "value".
        set {
            name = value;
        }
    }
}
```

# Utilizzare le Property

Creiamo un'oggetto della classe Person e vediamo come se utilizza in concreto la Property "Name" che e' stata definita:

**Modalita' set**
```
Person person = new Person();
person.Name = "Mario";
Console.WriteLine(person.Name);
```

**Modalita' get**
```
Person person = new Person();
person.Name = "Mario";
Console.WriteLine(person.Name);
```

# I Backing Fields

Come gestire la variabile d'istanza che sta nascosta dietro una Property?
La variabile d'istanza nascosta dietro una Property si chiama **Backing Field**

**PROPERTY READ-ONLY**
```
public class Person {
    private string name;
    private string lastName;
    
    ...

    public string Denomination {
        get {
            return name + " " + lastName;
        }
    }
}
```

**LIVELLO DI VISIBILITA' DI UNA PROPERTY**
```
public class Person {
    private string name;

    public string Name {
        get {
            return name;
        }

        private set {
            name = value;
        }
    }
}
```

# Property Auto-Implementate

Si puo' fare passando da questa dichiariazione:
```
public class Person {
    private string name;

    public string Name {
        get {
            return name;
        }

        set {
            name = value;
        }
    }
}
```

a questa:
```
public class Person {
    public string Nome{ get; set; }  // Auto-implemented property
}
```

Il compilatore crea un **Backing Field** e la copia dei metodi **set** and **get**.

**VALORE DI DEFAULT**
'E possibile indicare al compilatore che la Property ha un valore di default che verra' ritornato se non viene impostato esplicitamente con la parte **set** della Property:
```
public class Person {
    public string Nome{ get; set; } = "Mario";
}
```

# L'Object Initializer

Permette di usare una nuova forma sintattica per istanziare un oggetto con un numero minore di codice.
**L'Object Initializer** permette di creare un nuovo oggetto assegnandole una serie di proprieta' (anche dei valori per i campi) purche' siano pubblici.

**OBJECT INITIALIZER**
Si passa da questa forma d'istanziare una classe:
```
Person a = new Person();
person.Name = "Mario";
person.LastName = "Rossi";
```

a questa forma:
```
Person person = new Person {Name = "Mario", LastName = "Rossi"};
```

**IMPORTANTE**: Con l'utilizzo dell'Object Initializer il costruttore che sia stato definito per la classe deve essere rimoso.