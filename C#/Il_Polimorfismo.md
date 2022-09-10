# Introduzione

A partire di una classe base e' possibile creare delle classi derivate che fanno tutte la stessa cosa, ma ciascuna a modo suo.

# Metodi Virtuali e Override

1. Nel metodo della classe di base dobbiamo aggiungere la keyword **virtual** nella signature del metodo, davanti al tipo di ritorno.
2. Nella classe derivata, aggiungere la keyword **override** nella signature del metodo, davanti al tipo di ritorno.

**NON e' obbligatorio eseguire l'override di un metodo definito virtual**.

**VIRTUAL METHOD**
```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public class BClass : AClass {
    public override void myMethod() {
        Console.WriteLine("BClass:myMethod");
    }
}
```

# Metodi e Classi Astratte

1. La classe di base deve essere dichiarata come **abstract**.
2. La signature del metodo nella classe di base sara' senza nessuna business logic, e conterra' la keyword **abstract**.
3. L'implementazione/override del metodo sara' fatta nelle classi derivate, mantenendo sempre la keyword **override** nella signature del metodo.

**ABSTRACT METHOD**
```
public abstract class AClass {
    public abstract void myMethod() {
    }
}

public class BClass : AClass {
    public override void myMethod() {
        Console.WriteLine("BClass:myMethod");
    }
}
```

# La keyword 'base' e l'Override

Estendere e redefinire il metodo di una classe base in una classe derivata eseguendo anche il codice che è presente nel metodo di cui eseguiamo l'override.

1. Si aggiunge uno statement nel quale è presente la keyword **base** (la classe base), seguita dalla'invocazione
   del metodo della classe base (**base.<method_name>**).

```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public class BClass : AClass {
    public override void myMethod() {
        base.myMethod();
        Console.WriteLine("BClass:myMethod");
    }
}

BClass bClass = new BClass();
bClass.myMethod();  // "AClass:myMethod"
                    // "BClass:myMethod"
```

Si può inserire la keyword **base** anche in altri punti del codice all'interno del metodo della classe derivata.

```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public class BClass : AClass {
    public override void myMethod() {
        Console.WriteLine("BClass:myMethod");
        base.myMethod();
    }
}

BClass bClass = new BClass();
bClass.myMethod();  // "BClass:myMethod"
                    // "AClass:myMethod"
```

# Polimorfismo "In Action"

**POLIMORFISMO**

```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public class BClass : AClass {
    public override void myMethod() {
        Console.WriteLine("BClass:myMethod");
        base.myMethod();
    }
}

public class CClass : AClass {
    public override void myMethod() {
        Console.WriteLine("CClass:myMethod");
        base.myMethod();
    }
}

AClass bClass = new BClass();
AClass cClass = new CClass();

bClass.myMethod();  // "BClass:myMethod"
cClass.myMethod();  // "CClass:myMethod"
```

# Metodi e Classi "Sealed"

La keyword **sealed** può essere applicata sia ai metodi che a le classi, ma con un significato diverso tra loro:
1. Applicata ad un metodo, impedisce la progressione dell'override di un metodo nelle sottoclassi.

**SEALED METHOD**
```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public class BClass : AClass {
    public sealed override void myMethod() {
        Console.WriteLine("BClass:myMethod");
        base.myMethod();
    }
}

public class CClass : BClass {
    public override void myMethod() {    // ERRORE!!
        Console.WriteLine("CClass:myMethod");
        base.myMethod();
    }
}
```

Facendo così, si otterrebbe un errore di compilazione in tutte le sottoclassi di BClass in cui si tentasi di eseguire un'override del metodo myMethod.

**SEALED CLASS**
```
public class AClass {
    public virtual void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

public sealed class BClass : AClass {
    public sealed override void myMethod() {
        Console.WriteLine("BClass:myMethod");
        base.myMethod();
    }
}

public class CClass : BClass {           // ERRORE!!
    public override void myMethod() {    // ERRORE!!
        Console.WriteLine("CClass:myMethod");
        base.myMethod();
    }
}
```

Facendo così, si impedisce alla classe di essere ereditata, e trasformiamo questa classe in una **classe finale**.