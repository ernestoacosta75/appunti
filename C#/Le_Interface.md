* Le Classi supportano solo l'**Ereditarietà Singola**.
* Le Classi supportano i **metodi astratti**.
* Le Classi stesse possono essere **astratte**.
* Le Classi sono un **Reference Type**.

**INTERFACE**
* Una Interface è un **tipo reference**, come la Classe.+
* Una Interface definisce un insieme di **metodi astratti**.
* Può contenere anche la definizione di property ed altri costrutti.
* Una Classe può **implementare una o più** interface.
* Una interface può **derivare da una o più** interface. (ereditarietà multipla tra interface)
* Si può **ottenere un reference** ad una interface. (polimorfismo)

# Dichiarare una Interface

```
public interface IMyInterface {
    void myMethod();
    int MyPty { get; set; }
}
```

**IMPLEMENTAZIONE DI UNA INTERFACE**

```
public interface IMyInterface {
    void myMethod();
    int MyPty { get; set; }
}

class AClass : IMyInterface {
    public int MyPty { get; set; }

    public void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}
```

**IMPLEMENTAZIONE DI PIÙ INTERFACE**

```
class BClass : AClass, IMyInterface1, IMyInterface2 {
    // ...
    // ...
}
```

# Utilizzare una Interface

**IMPLEMENTAZIONE DI UNA INTERFACE**

```
public interface IMyInterface {
    void myMethod();
}

class AClass : IMyInterface {
    public void myMethod() {
        Console.WriteLine("AClass:myMethod");
    }
}

AClass aClass = new AClass();

// CONVERSIONE DI CLASSE A INTERFACE
IMyInterface iMyInterface = a as IMyInterface;
```

**UNA INTERFACE COME PARAMETRO**

```
public class XClass {i
    public static void met(IMyInterface iMyInterface) {
        iMyInterface.myMethod();
    }
}

AClass aClass = new AClass();
XClass.met(aClass);
```