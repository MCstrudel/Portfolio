
import java.util.Iterator;
import java.lang.Iterable;


public class Lenkeliste <T> implements Liste<T>,Iterable<T>{
    public class LenkelisteIterator implements Iterator<T>{
        private Lenkeliste<T> liste;
        private Node currentNode;

        public LenkelisteIterator(Lenkeliste l){
           liste=l;
           currentNode=liste.hentHode();
        }

        public void reset(){
            currentNode=liste.hentHode();
        }
        public T neste(){
            Node supertmp=currentNode;
            if(currentNode!=null){
                Node tmp=currentNode.hentLinkTil();
                currentNode=tmp;
            }
            return supertmp.hentNokkel();
        }
        public void forrige(){
            Node tmp=currentNode.hentLinkFra();
            currentNode=tmp;
        }
        public Node hentNode(){
            return currentNode;
        }
        public void hoppTil(int pos){
            reset();
            for(int i=0;i<pos;i++){
                neste();
            }
        }

        @Override
        public boolean hasNext() {
            if(currentNode!=null){
                    return true;
            }else{
                    return false;
                }
        }

        @Override
        public T next() {
            return this.neste();
        }

        @Override
        public void remove() {
        }
    }

    public class Node{
        private Node linkFra;
        private Node linkTil;
        private T nokkel;

        public Node(T nokk, Node lT, Node lF){
            nokkel=nokk;
            linkTil=lT;
            linkFra=lF;
        }
        public boolean erHode(){
            if(linkFra==null){
                return true;
            }else{
                return false;
            }
        }
        public boolean erHale(){
            if(linkTil==null){
                return true;
            }else{
                return false;
            }
        }
        public T hentNokkel(){
            return nokkel;
        }
        public Node hentLinkFra(){
            return linkFra;
        }
        public Node hentLinkTil(){
            return linkTil;
        }
        public void settNokkel(T x){
            nokkel=x;
        }
        public void settLinkFra(Node n){
            linkFra=n;
        }
        public void settLinkTil(Node n){
            linkTil=n;
        }
    }

    private Node hode;
    private Node hale;
    private LenkelisteIterator iterator;
    private int stoerrelse;

    public Lenkeliste(){
        stoerrelse=0;
        iterator=(LenkelisteIterator)iterator();
        hode=null;
        hale=null;
    }

    public Node hentHode(){
        return hode;
    }
    public Node hentHale(){
        return hale;
    }

    @Override
    public int stoerrelse() {
        return stoerrelse;
    }

    @Override
    public void leggTil(int pos, T x){
        if(pos<=stoerrelse&&pos>=0){
            iterator.hoppTil(pos);
            Node pry=iterator.hentNode();
            if(pry!=null){
                stoerrelse++;
                Node tmp=new Node(x,pry,null);
                if(pry.erHode()){
                    hode=tmp;
                }else{
                    iterator.forrige();
                    Node ur=iterator.hentNode();
                    ur.settLinkTil(tmp);
                    iterator.reset();
                }
                pry.settLinkFra(tmp);
            }else if(pos==0){
                stoerrelse++;
                Node tmp=new Node(x,null,null);
                hode=tmp;
                hale=tmp;
                iterator.reset();
            }else if(pos==stoerrelse){
              stoerrelse++;
              Node tmp=new Node(x,null,null);
              tmp.settLinkFra(hale);
              hale.settLinkTil(tmp);
              hale=tmp;
              iterator.reset();
            }else{
                throw new UgyldigListeIndeks(pos);
              }
        }else{
            throw new UgyldigListeIndeks(pos);
          }
    }

    @Override
    public void leggTil(T x){
        if(hode!=null){
            stoerrelse++;
            Node tmp=new Node(x,null,hale);
            hale.settLinkTil(tmp);
            hale=tmp;
        }else{
            stoerrelse++;
            Node tmp=new Node(x,null,null);
            hode=tmp;
            hale=tmp;
        }
    }

    @Override
    public void sett(int pos, T x){
        if(pos<stoerrelse&&pos>=0){
            iterator.hoppTil(pos);
            if(iterator.hentNode()!=null){
              iterator.hentNode().settNokkel(x);
              iterator.reset();
            }else{
              throw new UgyldigListeIndeks(pos);
            }
        }else{
            throw new UgyldigListeIndeks(pos);
        }
    }

    @Override
    public T hent(int pos){
        if(pos<stoerrelse&&pos>=0){
            iterator.hoppTil(pos);
            if(iterator.hentNode()!=null){
                T tmp= iterator.hentNode().hentNokkel();
                iterator.reset();
                return tmp;
            }else{
                throw new UgyldigListeIndeks(pos);
            }
        }else{
             throw new UgyldigListeIndeks(pos);
        }
    }

    @Override
    public T fjern(int pos){
        if(pos<stoerrelse&&pos>=0){
            iterator.hoppTil(pos);
            Node pry=iterator.hentNode();
            if(pry!=null){
                stoerrelse--;
                if(pry.erHode()){
                    if(pry.erHale()){
                        hode=null;
                        hale=null;
                    }else{
                        Node nxt=pry.hentLinkTil();
                        hode=nxt;
                        nxt.settLinkFra(null);
                    }
                }else if(pry.erHale()){
                    Node ur=pry.hentLinkFra();
                    hale=ur;
                    ur.settLinkTil(null);
                }else{
                    pry.hentLinkFra().settLinkTil(pry.hentLinkTil());
                    pry.hentLinkTil().settLinkFra(pry.hentLinkFra());
                }
                return pry.hentNokkel();
            }else{
                throw new UgyldigListeIndeks(pos);
            }
        }else{
            throw new UgyldigListeIndeks(pos);
        }
    }

    @Override
    public T fjern() {
        Node tmp=hode;
        if(tmp!=null){
            stoerrelse--;
            if(!tmp.erHale()){
                hode=tmp.hentLinkTil();
                tmp.hentLinkTil().settLinkFra(null);
            }else{
                hode=null;
                hale=null;
            }
            return tmp.hentNokkel();
        }else{
            throw new UgyldigListeIndeks(-1);
            }
    }

    public void settHode(Node n){
        hode=n;
    }
    public void settHale(Node n){
        hale=n;
    }
    public void oekStoerr(){
        stoerrelse++;
    }
    public void trekkStoerr(){
        stoerrelse--;
    }

    @Override
    public Iterator iterator(){
        return new LenkelisteIterator(this);
    }

}
