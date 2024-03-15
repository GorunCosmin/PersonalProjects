package com.example.proiectpoo;

import data_baze.Insert;
import data_baze.NewResult;
import data_baze.ResultToString;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.sql.ResultSet;

public class HelloController {
    @FXML
    private Label TabelText;
    public TextField idf,numef,stare,orasf,idc,numec,culoare,masa,orasc,idp,numep,orasp,searchidf,searchidc,searchidp;
    @FXML
    protected void onFurnizoriButtonClick() {
        ResultSet result= NewResult.getResult("select idf,numef,stare,oras from furnizori");
        String string= ResultToString.resultToString(result,"idf","numef","stare","oras");
        TabelText.setText(string);
    }
    public void onComponenteButtonClick() {
        ResultSet result= NewResult.getResult("select idc,numec,culoare,masa,oras from componente");
        String string= ResultToString.resultToString(result,"idc","numec","culoare","masa","oras");
        TabelText.setText(string);
    }
    public void onProiecteButtonClick() {
        ResultSet result= NewResult.getResult("select idp,numep,oras from proiecte");
        String string= ResultToString.resultToString(result,"idp","numep","oras");
        TabelText.setText(string);
    }
    public void onLivrariButtonClick() {
        ResultSet result= NewResult.getResult("select idf,idc,idp,cantitate from livrare");
        String string= ResultToString.resultToString(result,"idf","idc","idp","cantitate");
        TabelText.setText(string);
    }
    public void insertFurnizori(){
        Insert a= new Insert();
        a.InsertTable("Furnizori",idf.getText(),numef.getText(),stare.getText(),orasf.getText());
    }
    public void insertComponenta(){
        Insert a= new Insert();
        a.InsertTable("componente",idc.getText(),numec.getText(),culoare.getText(),masa.getText(),orasc.getText());
    }
    public void insertLivrare(){
        Insert a= new Insert();
        a.InsertTable("proiecte",idp.getText(),numep.getText(),orasp.getText());
    }
    public void cautaFurnizor(){
        String query="select idf,numef,stare,oras from furnizori where idf='"+searchidf.getText()+"'";
        ResultSet result= NewResult.getResult(query);
        String string= ResultToString.resultToString(result,"idf","numef","stare","oras");
        TabelText.setText(string);
    }
    public void cautaComponenta(){
        String query="select idc,numec,culoare,masa,oras from componente where idc='"+searchidc.getText()+"'";
        ResultSet result= NewResult.getResult(query);
        String string= ResultToString.resultToString(result,"idc","numec","culoare","masa","oras");
        TabelText.setText(string);
    }
    public void cautaProiect(){
        String query="select idp,numep,oras from proiecte where idp='"+searchidp.getText()+"'";
        ResultSet result= NewResult.getResult(query);
        String string= ResultToString.resultToString(result,"idp","numep","oras");
        TabelText.setText(string);
    }
}