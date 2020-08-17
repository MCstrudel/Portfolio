
public class Stabel<T> extends Lenkeliste<T>{
    public void leggPaa(T x){
        if(stoerrelse()>0){
            leggTil(stoerrelse(),x);
        }else{
            leggTil(x);
        }

    }
    public T taAv(){
        if(stoerrelse()>0){
            return (T)fjern(stoerrelse()-1);
        }else{
            throw new UgyldigListeIndeks(-1);
        }

    }
}
