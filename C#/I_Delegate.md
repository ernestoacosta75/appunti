# Definire i Delegate

I **Delegate** sono un reference type con la caratteristica particolare che le sue istanze sono dei **metodi**.
In altre parole, un **Delegate** ci consente di trattare i metodi come se fossero degli oggetti asestanti.

**DEFINIZIONE DI UN DELEGATE**

Un Delegate viene definitino all'interno di un **namespace**, proprio come una classe o una struttura.
Un Delegate assomiglia molto alla dichiarazione di un metodo all'interno di una interface (senza fornire nessuna implementazione), aggiungendo la keyword **delegate** dopo il livelo di accesso del metodo (public, protected, ecc...).

```
namespaces Delegates {
    public delegate bool ConfrontoDelegate(int x, int y);
}
```

In questo esempio, stiamo introducendo un Delegate di nome *ConfrontoDelegate*. Questo particolare Delegate rappresenta un **qualunque metodo** che prenda in input due interi e che ne ritorni uno come boolean.

Un Delegate puo' anche essere definito all'interno di una classe. In quel caso pero', per poter essere utilizzato al di fuori della classe, dovra' avere una vissibilita' **pubblica**, e si dovra' ussare il nome completo per riferirsi al Delegate.

```
namespaces Delegates {
    public class MyClass {
        public delegate bool ConfrontoDelegate(int x, int y);
    }
}
```

# Utilizzare i Delegate

**DEFINIZIONE DI UN DELEGATE**

```
public delegate bool ConfrontoDelegate(int x, int y);
```

**DEFINIZIONE DI METODI CON STESSA SIGNATURE**

```
public bool GreaterThan(int x, int y) {
    return (x > y) ? true : false;
}

public bool LessThan(int x, int y) {
    return (x < y) ? true : false;
}

public bool EqualsTo(int x, int y) {
    return (x == y) ? true : false;
}

...

static void Main (string[] args) {
    Program p = new Program();

    ConfrontoDelegate cd = p.GreaterThan;
    Console.WriteLine(cd(10, 4));

    ConfrontoDelegate cd = p.LessThan;
    Console.WriteLine(cd(10, 4));

    ConfrontoDelegate cd = p.EqualsTo;
    Console.WriteLine(cd(10, 4));
}
```

**UTILIZZO DEI DELEGATE CON NEW**

```
ConfrontoDelegate cd = new ConfrontoDelegate(p.GreaterThan);
```

Essiste un modo alternativo di eseguire un Delegate.
Oltre a usa direttamente il nome della variabile che rappresenta il Delegate fornendo i parametri tra parentisi, possiamo usare anche il metodo **invoke**, che e' presente in tutti gli oggetti Delegate, per ottenere di fatto lo stesso risultato:

```
cd = p.GreatherThan;

cd(10, 4);

cd.Invoke(10, 4);
```

# I Delegate Multicast

Attraverso il multicast, possiamo usare un Delegate per invocare direttamente non uno, ma una serie di metodi anche appartenenti ad oggetti differenti, che siano stati assegnati preventivamente alla stessa istanza del Delegate.

**UTILIZZO DEI DELEGATE IN MULTICAST**

```
public delegate void ConfrontoDelegate(int x, int y);

...

public void GreaterThan(int x, int y) {
    bool result = (x > y) ? true : false;
    Console.WriteLine(result);
}

public void LessThan(int x, int y) {
    bool result = (x < y) ? true : false;
    Console.WriteLine(result);
}

public void EqualsTo(int x, int y) {
    bool result = (x == y) ? true : false;
    Console.WriteLine(result);
}

...

static void Main (string[] args) {
    Program p = new Program();

    ConfrontoDelegate cd = p.GreaterThan;
    // Like this, the Delegate contains the reference to two methods at the same time
    cd += p.GreatherTnan;

    // Like this, the Delegate contains the reference to three methods at the same time
    cd += p.EqualsTo;

    // The three methods will be called in sequence
    cd(10, 4);  // True False False
}
```

**EFFETTI COLLATERALI PER IL MULTICAST**

* Il valore di ritorno del Delegate e' il risultato dell'ultimo metodo.
* Una qualunque eccezione interrompe il multicast

# I Delegate Generici

```
public delegate void ConfrontoDelegate<T>(T x, T y);
```

Si possono usare anche dei type costraint:

```
public delegate void ConfrontoDelegate<T>(T x, T y) where T : struct;

...

public void GreaterThan(double x, double y) {
    bool result = (x > y) ? true : false;
    Console.WriteLine(result);
}

public void LessThan(int x, int y) {
    bool result = (x < y) ? true : false;
    Console.WriteLine(result);
}

...

static void Main (string[] args) {
    Program p = new Program();

    ConfrontoDelegate<double> cd1 = p.GreaterThan;
    ConfrontoDelegate<int> cd2 = p.LessThan;

    cd1(12.6, 5.8); // True
    cd2(10, 4);     // False
}
```