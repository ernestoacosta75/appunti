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

