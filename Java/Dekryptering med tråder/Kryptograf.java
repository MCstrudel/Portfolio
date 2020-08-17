
import java.util.*;
public class Kryptograf extends Thread{
    public static Monitor telegraf;
    public static Monitor monitor;
    private boolean ferdig;

    public Kryptograf(Monitor t, Monitor m){
        monitor=m;
        monitor.leggTilArbeider();
        ferdig=false;
        telegraf=t;
        
    }

    @Override
    public void run(){
        while(monitor.kanalerAapne()&&!ferdig){

                Melding tmp=telegraf.giArbeid();
                System.out.println("Kryptograf har dekryptert melding fra kanal "+tmp.hentKanalID()+". Prøver å legge til i monitor.");

                monitor.leggTil(new Melding(Kryptografi.dekrypter(tmp.hentMelding()),tmp.hentSekvensnummer(),tmp.hentKanalID()));
                System.out.println("Melding fra kanal "+tmp.hentKanalID()+" lagt til i monitor.");

            if(!telegraf.kanalerAapne()&&!telegraf.harTelegram()){
                monitor.ferdig();
                System.out.println("Ingen flere meldinger å dekryptere.");
                ferdig=true;
            }

        
        this.interrupt();
    }
    }
    public static Monitor getMonitor(){
        return monitor;
    }


}
