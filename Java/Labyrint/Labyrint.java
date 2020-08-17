
import java.util.*;
import java.io.*;

public class Labyrint {
    private Rute[][] rutenett;

    private Labyrint(Rute[] ruter,int kol,int rad){
        rutenett=new Rute[rad][kol];
        for(int i=0;i<rad;i++){
            for(int j=0;j<kol;j++){
                rutenett[i][j]=ruter[i*j+j];
            }
        }
        for(Rute[] r:rutenett){
            for(Rute k:r){
              Rute n=null;
              if(k.hentRad()>0){
                n=rutenett[k.hentRad()-1][k.hentKolonne()];
              }
              Rute h=null;
              if(k.hentKolonne()<kol-1){
                h=rutenett[k.hentRad()][k.hentKolonne()+1];
              }
              Rute s=null;
              if(k.hentRad()<rad-1){
                s=rutenett[k.hentRad()+1][k.hentKolonne()];
              }
              Rute v=null;
              if(k.hentKolonne()>0){
                v=rutenett[k.hentRad()][k.hentKolonne()-1];
              }
                k.settLinker(n,h,s,v);

            }
        }
        for(Rute[] r:rutenett){
            for(Rute k:r){
                k.settLabyrint(this);
            }
        }
    }

    public String[] tegnTabell(){
        ArrayList<String> tmp=new ArrayList<String>(0);
        for(Rute[] k:rutenett){
            String string="";
            for(Rute r:k){
                string=string+r.tilTegn();
            }
            tmp.add(string);
        }
        return (String[])tmp.toArray();
    }

    public static Labyrint lesFraFil(File bop) throws FileNotFoundException{
        int kolonner;
        int rader;

            Scanner fil=new Scanner(bop);
            ArrayList<String> tegn = new ArrayList<String>();
            rader=fil.nextInt();
            kolonner=fil.nextInt();
            Scanner line;
            while(fil.hasNextLine()){

                String x=fil.nextLine();
                for(char c:x.toCharArray()){

                    tegn.add(c+"");
                    System.out.print(c+"");
                }
            }
            for(String s:tegn){
              System.out.println(s);
            }

            int i=0;
            int j=0;
            Rute[] r=new Rute[(kolonner*rader)];
            for(int k=0;k<r.length;k++){
                if(tegn.get(i).equals(".")){
                    r[k]=new HvitRute(i,j);
                    tegn.set(k, r[k].tilTegn()+"");
                    if(r[k].erAapning()){
                        r[k]=new Aapning(i,j);
                    }
                }else{
                    r[k]=new SortRute(i,j);
                }
                if(i==kolonner-1){
                    i=0;
                    j++;
                }else{
                    i++;
                }

            }

            return new Labyrint(r,kolonner,rader);
    }
    public Liste<String> finnUtveiFra(int kol, int rad){
        Stabel<String> tmp=new Stabel<String>();

        String[] utveier=rutenett[rad][kol].finnUtvei();

            for(String k:utveier){
                tmp.leggPaa(k);
            }
        
        return tmp;
    }

}
