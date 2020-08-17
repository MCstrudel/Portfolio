
public class HvitRute extends Rute{

    public HvitRute(int k, int r) {
        super(k, r);
    }


    @Override
    public char tilTegn() {
        return '.';
    }

    @Override
    public boolean erAapning(){
        if(this.over()==null||this.hoyre()==null||this.under()==null||this.venstre()==null){
            return true;
        }else{
        return false;
        }
    }
}
