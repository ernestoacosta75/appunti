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

