# Classi Base e Classi Derivate

**Generalizzazione**

Superclasse         Veicolo a Motore        Motore
(Classe Base)               / \
                             |
                             |
Sottoclasse             Automobile          Numero di Portiere
(Classe Derivata)

**DERIVED CLASS**
```
public class AClass {
}

public class BClass : AClass {
}

public class CClass : BClass {
}
```

# L'ereditarietà

**INHERITANCE**
```
public class AClass {
    protected int aVar;
}

public class BClass : AClass {
    public string bVar;
}

BClass bClass = new BClass();
bClass.aVar = 10;
bClass.bVar = "chsarp";
```

# La keyword 'is'

```
public class AClass {
    protected int aVar;
}

public class BClass : AClass {
    private string bVar;
}

AClass bClass = new BClass();
bClass.aVar = 120;
bClass.bVar = "csharp"; // ERRORE! --> bClass viene visto solo come un'istanza di AClass
```

**LA KEYWPRDS 'IS'**

**is** viene usata per verificare se un oggetto è o non è un'istanza di una determinata classe, chiedendolo a runtime.

```
public class AClass {
    protected int aVar;
}

public class BClass : AClass {
    private string bVar;
}

AClass aClass = new BClass();

if )aClass is BClass) {
    BClass bClass = (BClass) aClass;
}
```

**LA KEYWPRDS 'AS'**

Rappresenta un modo alternativo di eseguire il casting da un tipo di oggetto ad un'altro.

```
public class AClass {
    protected int aVar;
}

public class BClass : AClass {
    private string bVar;
}

AClass aClass = new BClass();

BClass bClass = aClass as BClass;
```

# Costruttori ed Ereditarietà

**INSERIMENTO DI "BASE" NEL CONSTRUTTORE**

Nel costruttore della classe derivata si aggiunge/aggiungono i parametri necessari per soddisfare il parametro/parametri della classe base, insieme all'utilizzo de la keyword **base** con la sintassi:

**: base(<base_class_parameters>)**.

La keyword **base** provoca la chiamata ad uno dei costruttori della classe base.

```
public class AClass {
    private int aVar;

    public AClass(int aVar) {
        this.aVar = aVar;
    }
}

public class BClass : AClass {
    private string bVar;

    public BClass(string bVar, int aVar) : base(aVar) {
        this.bVar = bVar;
    }
}

BClass bClass = new BClass("csharp", 10);
```