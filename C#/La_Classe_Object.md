# La Classe System.Object

É la radice di tutti i tipi presenti in C#, sia quelli predefiniti che quelli custom.

La classe **System.Object** puó essere rappresentata anche attraverso la keyword **object**.

```
public class AClass : object
{
    public virtual void MyMethod()
    {
        Console.WriteLine("AClass:MyMethod");
    }
}

public class BClass : AClass
{
    public override void MyMethod()
    {
        Console.WriteLine("BClass:MyMethod");
    }
}

public class CClass : BClass
{
    public override void MyMethod()
    {
        Console.WriteLine("CClass:MyMethod");
    }
}
```

# Il Metodo ToString()

**public virtual string? ToString()**

Questo metodo ha giá un comportamento predefinito che viene ereditato.

Se si vuole visualizzare il valore dell'istanza **Book**, apparirà **Book** perchè se si visualizza il reference che è associato ad una variabile, specificando il nome della variabile direttamente, **viene visualizato il nome del tipo** a cui questa variabile appartiene.

Se invece invociamo il metodo **ToString()** sull'oggetto, ereditato dalla classe **Object**, il risultato sarà identico.

Eseguendo l'override di questo metodo, si può avere un risultato più espansivo.

È una best pratice quando si fa l'override di questo metodo, di invocare anche il metodo ToString() dell'immediata superclasse dell'oggetto, se per caso è stato predefinito. In questo modo, siamo sicuri di non perdere delle informazioni.

```
using System;

class Book
{
    public string TitLe { get; set; }
    public string Author { get; set; }

    public override string ToString()
    {
        return $"{base.ToString()}: {Title} from {Author}";
    }
}

...

Book myBook1 = new Book { Title = "L'Isola Misteriosa", Author = "Jules Verne" };
Console.WriteLine(myBook1.ToString()); // Book: L'Isola Misteriosa from Jules Verne
```

# Il Metodo GetHashCode()

**public virtual int GetHashCode()**

Questo metodo ritorna il codice hash di un ogetto. Un **hash** è un numero intero che rappresenta in modo univoco un oggetto, sulla base di una serie di fattori che possono essere decisi di volta in volta in base al tipo sul quale si definisce la regola di produzione di questo hash.

Nell'esempio, se viene invocato il metodo **GetHashCode()** su entrambe le istanze, otterremo due hash diversi, essendo in presenza di due reference diversi, anche si hanno gli stessi valori nelle loro proprietà.

```
using System;

class Book
{
    public string TitLe { get; set; }
    public string Author { get; set; }
}

...

Book myBook1 = new Book { Title = "L'Isola Misteriosa", Author = "Jules Verne" };
Book myBook2 = new Book { Title = "L'Isola Misteriosa", Author = "Jules Verne" };

Console.WriteLine(myBook1.GetHashCode()); // 58225482
Console.WriteLine(myBook2.GetHashCode()); // 54267293
```

Se viene assegnato il reference del primo oggetto al secondo, le due variabili punteranno allo stesso oggetto, ed il loro has code diventerà uguale.

```
myBook2 = myBook1;

Console.WriteLine(myBook1.GetHashCode()); // 58225482
Console.WriteLine(myBook2.GetHashCode()); // 58225482
```

Per alterare il meccanismo di default di produzione dell'hash code, si fa l'override del metodo **GetHashCode()** ereditato dalla classe **Object** o classe di base di cui derivano le nostre istanze.

Si applica il metodo **GetHashCode()** alla stringa che si ottiene dall'override del metodo **ToString()**. Questo ci garantirà che otterremo lo stesso hash code per gli oggetti Book, quando questi oggetti hanno lo stesso valore nelle loro proprietà.

```
using System;

class Book
{
    public string TitLe { get; set; }
    public string Author { get; set; }

    public override string ToString()
    {
        return $"{base.ToString()}: {Title} from {Author}";
    }

    public override int GetHashCode()
    {
        return this.ToString().GetHashCode();
    }
}

...

Book myBook1 = new Book { Title = "L'Isola Misteriosa", Author = "Jules Verne" };
Book myBook2 = new Book { Title = "L'Isola Misteriosa", Author = "Jules Verne" };

Console.WriteLine(myBook1.GetHashCode()); // -1006577443
Console.WriteLine(myBook2.GetHashCode()); // -1006577443
```

Un'altra maniera di ottenere lo stesso risultato, è quello di usare la struct **HashCode**. Essa può essere utilizzata per produrre degli hash code tramite una serie di metodi, che combinano tra di loro una serie di argomenti.

Uno di questi metodi, il metodo generico **Combine**, ritorna l'hash code del valore ottenuto combinando tra loro i valori dei due argomenti che vengono passati al metodo.

**public static int Combine<T1, T2>(T1 value1, T2 value2);**

Questo metodo si può utilizzare per andare a modificare le nostre classi custom nell'override del metodo GetHashCode().


# Il Metodo Equals()

Ci sono due versioni del metodo **Equals**: una **d'istanza** e l'altra di **classe**.

La più comune è questa:

**public virtual bool Equals(object? obj);**

Il concetto di uguale si riferisce ai references, quindi, a due variabili che sono uguali se puntano allo stesso oggetto.

Portiamo la semantica del metodo Equals() a valore nel suo override:

```
public override bool Equals(object obj)
{
    return (this.ToString() == obj.ToString());
}
```

Ritornerà **True** se la rappresentazione sotto forma di stringa dei due oggetti è uguale.

Esiste una correlazione tra il metodo **Equals()** ed il metodo **GetHashCode()**, ragione per la quale se facciamo l'overide del metodo Equals() dobbiamo fare anche l'override del metodo GetHashCode().

L'altra forma del metodo Equals() (**di classe**) è la seguente:

**public static virtual bool Equals(object? objA, object? objB);**
