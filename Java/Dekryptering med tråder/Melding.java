
public class Melding {
    private String melding;
    private int sekvensnummer;
    private int kanalID;

     public Melding(String m, int seq,int kid){
         melding=m;
         sekvensnummer=seq;
         kanalID=kid;
     }

     public String hentMelding(){
         return melding;
     }

     public int hentSekvensnummer(){
         return sekvensnummer;
     }

     public int hentKanalID(){
         return kanalID;
     }
}
