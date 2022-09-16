# Value Type, Value Parameter (ParametriValueTypeEReference)

Differenza quando si parla di parametri valore e parametri reference.
Di norma, il passaggio di un parametro in un argumento in C# avviene **by value**.

# Reference Type, Value Parameter (ParametriValueTypeEReference)

Il reference type viene passato come un argomento ad un metodo, però il passaggio avviene comunque **by value**.

Il parametro del metodo invocato è un **value parameter**, e quello che succede è che il reference type passato al metodo viene duplicato nel parametro del metodo, e quindi, durante l'esecuzione del metodo ci saranno due references que puntano ad uno stesso oggetto.

Questo significa che quando dentro il metodo viene modificato il valore di uno degli attributi del reference passato come parametro, **verrà modificato lo stesso oggetto**.

Se invece, al reference passato come parametro al metodo, viene assegnata una nuova istanza del reference type, esso verrà associato ad una nuova istanza e l'ulteriore modifica degli attributi verrà assegnata a questa istanza, **e non a quella che è stata passata come parametro**.

# Reference Parameters: il Modificatore 'ref'

I **reference parameters** e' lo strumento che C# mette a disposizione per gestire i parametri tramite **riferimento**, non piu' tramite **valore**. Si tratta de la possibilita' di eseguire un passaggio di un argomento ad un parametro **by reference**.

Per farte questo, si utlizza il modificator **ref**. Esso altera la semantica del passaggio degli argomenti ad un metodo, provocando il passaggio **by reference**.

Il modificatore **ref** deve essere usato nella dichiarazione di un metodo, prima del tipo del parametro. La argomento che si potra' fornire al metodo adesso, deve essere per forza una variabile e questa variabile **deve avere gia' un valore assegnato**, prima di poterla passare come argomento al metodo.

Se il tipo del parametro e' un **reference type**, la variabile che rappresenta l'argomento puo' essere anche impostata ad **un oggetto**, ma anche a **null**, prima della chiamata al metodo.

Il modificatore **ref** deve essere utilizzato poi al momento dell'invocazione del metodo, prima del nome dell'argomento.

**DICHIARAZIONE**

```
void MyMethod(ref int x) {...}

int y = 5;
MyMethod(ref y);
```