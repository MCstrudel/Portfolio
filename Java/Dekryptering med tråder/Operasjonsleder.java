

import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

public class Operasjonsleder extends Thread{
    public static Monitor kryptograf;
    private File[] filer;
    private int kanaler;
    private Operasjonssentral arbeidsplass;
    private boolean ferdig;
    private PrintWriter[] skrivemaskin;
    public Operasjonsleder(Operasjonssentral o, Monitor k){
        kryptograf=k;
        arbeidsplass=o;
        kanaler=arbeidsplass.hentAntallKanaler();
        filer=new File[kanaler];
        for(int i=0;i<kanaler;i++){
          filer[i]=new File("kanal"+i);
        }
        ferdig=false;
        skrivemaskin=new PrintWriter[kanaler];
        try{
        for(int i=0;i<kanaler;i++){
            skrivemaskin[i]=new PrintWriter(filer[i],"utf-8");
        }
        }
        catch(FileNotFoundException e){
        }catch(UnsupportedEncodingException e){}
    }

    @Override
    public void run(){
      while(!sjekkFerdig()){
                
                Melding tmp=kryptograf.giArbeid();
                System.out.println("Sjefen har mottatt dekryptert melding fra kanal "+tmp.hentKanalID());
                skrivemaskin[tmp.hentKanalID()-1].println(tmp.hentMelding());
                skrivemaskin[tmp.hentKanalID()-1].println("");
                
      }
      
    }

    public boolean sjekkFerdig(){
        if(!kryptograf.harTelegram()&&!kryptograf.kanalerAapne()){
            for(int i=0;i<kanaler;i++){
                skrivemaskin[i].close();
            }
            ferdig=true;
            this.interrupt();
        }
        return ferdig;
    }
}
