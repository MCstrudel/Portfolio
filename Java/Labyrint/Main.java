
import javafx.application.*;

import javafx.scene.*;

import javafx.scene.control.*;

import javafx.scene.layout.*;

import javafx.stage.*;

public class Main extends Application{
    
    public static void main(String[] args){
        launch(args);
        
    }
    
    @Override
    public void start(Stage primaryStage) throws Exception {
        primaryStage.setTitle("Velg Labyrint");
        FileChooser filvindu=new FileChooser();
        File labyrintfil=filvindu.showOpenDialog(primaryStage)
        labyrintfil.setInitialDirectory();
    }
}
