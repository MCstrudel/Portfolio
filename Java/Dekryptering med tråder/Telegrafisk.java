
public class Telegrafisk extends Thread{
    private Kanal kanal;
    public static Monitor monitor=new Monitor();
    private int sekvens;
    private boolean ferdig;

    public Telegrafisk(Kanal k, Monitor m){
        monitor=m;
        monitor.leggTilArbeider();
        sekvens=0;
        kanal=k;
        ferdig=false;
        
    }

    @Override
    public void run(){
        while(monitor.kanalerAapne()&&!ferdig){
            String tmp=kanal.lytt();
            if(tmp!=null){
                System.out.println("Telegraf "+kanal.hentId()+" har hentet melding nr"+sekvens+". Prøver å legge til i monitor");

                monitor.leggTil(new Melding(Kryptografi.krypter("fisk "),sekvens,kanal.hentId()));
                System.out.println("Melding fra telegraf "+kanal.hentId()+" lagt til i monitor.");
                sekvens++;

            }else{
                sekvens=0;
                monitor.ferdig();
                System.out.println("Kanal "+kanal.hentId()+" er tom. Kanalen lukkes.");
                ferdig=true;
            }
        }
        this.interrupt();
    }

    public static Monitor getMonitor(){
        return monitor;
    }

}
