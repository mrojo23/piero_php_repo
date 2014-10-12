<?php
echo "Nombre Cliente: ".$nombre_cliente ."<br>";
echo "company name: ".$company_name."<br>";
echo "Fecha: ".$fecha."<br>";
echo "Agente: ".$agente."<br>";
echo "email: ".$email."<br>";
echo "telefono: ".$telefono."<br>";
echo "grupo: ".$grupo."<br>";
echo "Limite de Credito: ".$creditlimit."<br>";
echo "stop: ".$stop."<br>";
echo "Comentario: ".$comment."<br>";

if(empty($Sel_vproducts)) 
{
    echo("You didn't select any Product.");
} 
else
{
   $N = count($Sel_vproducts); 
   $S = count($Sel_vcustomerType);

   echo("You selected $N Products: <br>");
   echo("You selected $S Tipos: <br><br>");
   for($i=0; $i < $N; $i++)
   {
   	  $prod=$Sel_vproducts[$i];
   	  list($LprodPos, $prodID,$product) = explode("|", $prod);
   	  $tipo=$Sel_vcustomerType[$LprodPos];
      echo(($i+1).") Producto pos lista: ".$LprodPos." ID: ".$prodID." Producto: ".$product."<br>");
      list($LcTypePos, $cTypeID,$cType) = explode("|", $tipo);
      echo (" CType Value-> ".$tipo."<br>");
   }
 }//endif
 ?>