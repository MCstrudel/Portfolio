
import java.util.*;
import java.util.concurrent.locks.*;

public class Monitor {
    private ArrayList<Melding> meldinger;
    private boolean arbeid;
    private boolean arbeidAaFaa;
    private int arbeidere;
    private int ferdige;
    private ReentrantLock lock;
    final Condition notEmpty;

    public Monitor(){
        meldinger= new ArrayList<Melding>();
        arbeid=false;
        arbeidAaFaa=true;
        arbeidere=0;
        ferdige=0;
        lock= new ReentrantLock(true);
        notEmpty=lock.newCondition();
    }
    public ReentrantLock getLock(){
        return lock;
    }

    public boolean harTelegram(){
        return arbeid;
    }

    public void faaArbeid(){
        notEmpty.signal();
        arbeid=true;
    }

    public Melding giArbeid(){
      Melding tmp=null;

      lock.lock();

      try{

          while(meldinger.isEmpty()){
            notEmpty.await();

          }
        
            tmp=meldinger.get(meldinger.size()-1);
            meldinger.remove(meldinger.size()-1);
            if(meldinger.isEmpty()){
                arbeid=false;

          }
        }catch(InterruptedException e){}

      finally{
          System.out.println("uu");
          lock.unlock();
      }
    
      return tmp;
    }

    public void leggTilArbeider(){
        arbeidere++;
        if(!arbeidAaFaa){
            arbeidAaFaa=true;
        }
    }

    public void leggTil(Melding m){
        lock.lock();
        try{
          meldinger.add(m);
          faaArbeid();
        }
        finally{
            lock.unlock();
        }
    }

    public void ferdig(){
        ferdige++;
        if(ferdige>=arbeidere){

            arbeidAaFaa=false;
        }

    }

    public boolean kanalerAapne(){
        return arbeidAaFaa;
    }



}
