
import java.util.*;

public abstract class Rute {
    private int kolonne;
    private int rad;
    private Labyrint labyrint;
    private Rute nord;
    private Rute hoyre;
    private Rute sor;
    private Rute venstre;

    public Rute(int k,int r){
        kolonne=k;
        rad=r;
        nord=null;
        hoyre=null;
        sor=null;
        venstre=null;

    }

    public void settLinker(Rute n,Rute h,Rute s,Rute v){
        nord=n;
        hoyre=h;
        sor=s;
        venstre=v;
    }
    public void settLabyrint(Labyrint l){
        labyrint=l;
    }
    public int hentKolonne(){
        return kolonne;
    }
    public int hentRad(){
        return rad;
    }
    public Rute over(){
        return nord;
    }
    public Rute hoyre(){
        return hoyre;
    }
    public Rute under(){
        return sor;
    }
    public Rute venstre(){
        return venstre;
    }
    public Labyrint hentLabyrint(){
        return labyrint;
    }
    public abstract char tilTegn();
    public abstract boolean erAapning();

    public boolean kangaa(int retning){
        //nord-2 hoyre-3 sor-0 venstre-1
        switch(retning){
            case 0:
                retning=2;
                break;
            case 1:
                retning=3;
                break;
            case 2:
                retning=0;
                break;
            case 3:
                retning=1;
                break;
        }
        //nord-0 hoyre-1 sor-2 venstre-3
        boolean veiAaGaa=false;
        for(int i=0;i<4;i++){
            char b=retning(i).tilTegn();
            if(i!=retning&&b!='#'){
                if(!erAapning()){
                    veiAaGaa = retning(i).kangaa(i);
                }else{
                    veiAaGaa=true;
                }
            }
        }
        return veiAaGaa;
    }
    public String[] gaa(int retning){
        ArrayList<String> veiAaGaa=new ArrayList<String>(0);
        //nord-2 hoyre-3 sor-0 venstre-1
        switch(retning){
            case 0:
                retning=2;
                break;
            case 1:
                retning=3;
                break;
            case 2:
                retning=0;
                break;
            case 3:
                retning=1;
                break;
        }
        //nord-0 hoyre-1 sor-2 venstre-3
        for(int i=0;i<4;i++){
            if(i!=retning&&retning(i).tilTegn()!='#'){
                switch(i){
                    case 0:
                        veiAaGaa.add("("+nord.hentKolonne()+","+nord.hentRad()+")");
                        break;
                    case 1:
                        veiAaGaa.add("("+hoyre.hentKolonne()+","+hoyre.hentRad()+")");
                        break;
                    case 2:
                        veiAaGaa.add("("+sor.hentKolonne()+","+sor.hentRad()+")");
                        break;
                    case 3:
                        veiAaGaa.add("("+venstre.hentKolonne()+","+venstre.hentRad()+")");
                        break;
                }
                if(!erAapning()){
                    veiAaGaa.add(" --> ");
                    veiAaGaa.addAll(Arrays.asList(retning(i).gaa(i)));

                }
            }
        }
        for(int i=0;i<veiAaGaa.size();i++){
          String[] x=(String[])veiAaGaa.toArray();
          System.out.println(x[i]);
        }
        return (String[])veiAaGaa.toArray();
    }
    public String[] finnUtvei(){
        ArrayList<String> paths=new ArrayList<String>(0);
        for(int i=0;i<4;i++){     
            if(kangaa(i)){
                if(!erAapning()){
                    String[] x=gaa(i);
                    for(int j=0;j<x.length;j++){
                        paths.add(x[j]);
                    }
                }else{
                   
                }
            }
        }
        String[] x=new String[paths.size()];
        for(int i=0;i<paths.size();i++){
            x[i]=paths.get(i);
        }
        return x;
    }
    public Rute retning(int i){
        switch(i){
            case 0:
                return this.over();

            case 1:
                return this.hoyre();

            case 2:
                return this.under();

            case 3:
                return this.venstre();
            default:
                return null;
        }
    }

}
