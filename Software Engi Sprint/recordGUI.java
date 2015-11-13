//Lots of imports
import javafx.application.*;
import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.text.*;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.input.*;
import javafx.event.*;
import javafx.geometry.*;
import java.io.IOException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.*;
import java.util.*;
import java.util.Scanner;
import java.util.Set;
import java.util.List;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.HttpURLConnection;
import javax.net.ssl.HttpsURLConnection;
import java.net.URLEncoder;
public class recordGUI extends Application 
{
    public static void main(String[] args) 
    {
        launch(args);
        //launches program 
    }
    // HTTP GET request
    private void sendGet(String store_number, String address, String manager) {

        try {
            String url = "http://home.adelphi.edu/~da21066/SE/createStore.pl?store_number=" + URLEncoder.encode(store_number, "UTF-8") + "&address=" + URLEncoder.encode(address, "UTF-8")+ "&manager=" + URLEncoder.encode(manager, "UTF-8");
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();

            // optional default is GET
            con.setRequestMethod("GET");

            //add request header
            con.setRequestProperty("User-Agent", "Mozilla/5.0");

            int responseCode = con.getResponseCode();
            System.out.println("\nSending 'GET' request to URL : " + url);
            System.out.println("Response Code : " + responseCode);

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            //print result
            if(response.toString().contains("Success")) {
                System.out.println("Store successfully added to database!");
            } else {
                System.out.println("Store failed to add to database");
            }

        }
        catch(Exception e) {

        }
    }

    @Override
    public void start(final Stage theStage) 
    {
        //Setting up the window
        theStage.setTitle("Record Database");
        Group root = new Group();
        Scene theScene = new Scene(root, 300, 150);
        VBox vb1 = VBoxBuilder.create()
            .padding(new Insets(10))      // space outside of this box
            .spacing(10)                  // space between box elements
            .alignment(Pos.CENTER_LEFT)   // left-aligned by default
            .build();
        root.getChildren().add(vb1);    
        //In the window -- first line
        Label labelNum = new Label("Store #:");
        TextField storeField = new TextField ();

        HBox hb1 = HBoxBuilder.create()
            .spacing(10)
            .build(); 
        hb1.getChildren().addAll(labelNum, storeField);
        //In the window -- seocond line
        Label labelAddress = new Label("Address:");
        TextField addressField = new TextField ();

        HBox hb2 = HBoxBuilder.create()
            .spacing(10)
            .build(); 
        hb2.getChildren().addAll(labelAddress, addressField);
        //In the window -- third line
        Label labelMang = new Label("Manager:");
        TextField mangField = new TextField ();

        HBox hb3 = HBoxBuilder.create()
            .spacing(10)
            .build(); 
        hb3.getChildren().addAll(labelMang, mangField);
        //In the window -- Fourth line

        Button uploadButton = ButtonBuilder.create()
            .text("Upload Entry to Database")
            .onAction(new EventHandler<ActionEvent>()
                {
                    public void handle(ActionEvent ae)
                    {
                        String store_number = storeField.getText();
                        String address = addressField.getText();
                        String manager = mangField.getText();
                        sendGet(store_number, address, manager);
                    }
                })
            .build();

        HBox hb4 = HBoxBuilder.create()
            .spacing(10)
            .build(); 
        hb4.getChildren().addAll(uploadButton);

        vb1.getChildren().addAll(hb1, hb2, hb3, hb4);
        theStage.setScene(theScene);
        theStage.show();
    }
}