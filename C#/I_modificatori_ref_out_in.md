# Value Type, Value Parameter (ParametriValueTypeEReference)

Differenza quando si parla di parametri valore e parametri reference.
Di norma, il passaggio di un parametro in un argumento in C# avviene **by value**.

# Reference Type, Value Parameter (ParametriValueTypeEReference)

Il reference type viene passato come un argomento ad un metodo, però il passaggio avviene comunque **by value**.

Il parametro del metodo invocato è un **value parameter**, e quello che succede è che il reference type passato al metodo viene duplicato nel parametro del metodo, e quindi, durante l'esecuzione del metodo ci saranno due references que puntano ad uno stesso oggetto.

Questo significa che quando dentro il metodo viene modificato il valore di uno degli attributi del reference passato come parametro, **verrà modificato lo stesso oggetto**.

Se invece, al reference passato come parametro al metodo, viene assegnata una nuova istanza del reference type, esso verrà associato ad una nuova istanza e l'ulteriore modifica degli attributi verrà assegnata a questa istanza, **e non a quella che è stata passata come parametro**.

# Reference Parameters: il Modificatore 'ref'