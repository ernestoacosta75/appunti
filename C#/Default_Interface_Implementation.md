# Default Interface Implementation (C# v 8.x)

Se una interface contiene un metodo con un'implementazione di default, le classi che implementeranno questa interface, avranno due opzioni:

1. Redefinire la propria implementazione del metodo di default dell'interface. In seguito, il metodo potrà essere
   invocato tramite l'istanza della classe direttamente:
   ```
    public interface IMyInterface {
        void MyMethod(string value);
        string MyMethod2(string value) => value.ToUpper();
    }
    public class Program : IMyInterface
    {
        public void MyMethod(string value) => Console.WriteLine(value);
        string MyMethod2(string value) => value.ToLower();
        static void Main(string[] args)
        {
            Program aProgram = new Program();
            aProgram.MyMethod("Hello");
            string anString = aProgram.MyMethod2("Hello");
            Console.WriteLine(anString);
        }
    }
   ```
2. Se la classe che implementa l'interface non fornisce una propria implementazione del metodo di default
   dell'interfaccia, non potrà invocare questo metodo con la versione implementata in essa. In questo caso, per accedere al metodo implementato per default, si deve invocare in modo esplicito sull'interface procedendo in questo modo:
   - Indichiamo al compilatore che l'istanza della classe deve essere considerato non più come instanza della
     classe, ma deve essere considerato come una istanza di un tipo che implementa l'interface:
    ```
        public interface IMyInterface {
            void MyMethod(string value);
            string MyMethod2(string value) => value.ToUpper();
        }
        public class Program : IMyInterface
        {
            public void MyMethod(string value) => Console.WriteLine(value);
            static void Main(string[] args)
            {
                Program aProgram = new Program();
                aProgram.MyMethod("Hello");
                string anString = (aProgram as IMyInterface).MyMethod2("Hello");
                Console.WriteLine(anString);
            }
        }
    ```