
public class Meldingssentral{


    public static void main(String[] args){
        Monitor telegraf=new Monitor();
        Monitor kryptograf=new Monitor();
        int str=Tekster.ANTALL_TEKSTER;
        Operasjonssentral ops = new Operasjonssentral(str);
        Operasjonsleder sjef= new Operasjonsleder(ops, kryptograf);
        Kanal[] kanaler = ops.hentKanalArray();

        Telegrafisk[] telegrafister=new Telegrafisk[str];
        for(int i=0;i<str;i++){
          telegrafister[i]=new Telegrafisk(kanaler[i], telegraf);
        }
        Kryptograf[] kryptografer= new Kryptograf[str];
        for(int i=0;i<str;i++){
          kryptografer[i]=new Kryptograf(telegraf,kryptograf);
        }

       
        for(int i=0;i<str;i++){
            new Thread(telegrafister[i]).start();
        }
         for(int i=0;i<str;i++){
            new Thread(kryptografer[i]).start();
        }

        new Thread(sjef).start();





    }

}
