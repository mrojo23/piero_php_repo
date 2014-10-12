<?php

include_once("checkear_datos.php");
include_once("conexion.php");

$num_cliente=$_POST["num_cliente_txt"];
$company_name=$_POST["company_name_txt"];
$fecha=$_POST["fecha_txt"];
$agente=$_POST["agente_txt"];
$email=$_POST["email_txt"];
$telefono=$_POST["telefono_txt"];
$grupo=$_POST["grupo_sel"];
$creditlimit=$_POST["creditlimit_num"];
$stop=(isset($_POST["stop_cbx"])?"TRUE":"FALSE");
$comment=$_POST["comment_txa"];
$N_products=0;

if(isset($_POST['producto']))
{
   $Sel_vproducts=$_POST['producto'];
   $Sel_vcustomerType=$_POST['customerType'];
   if(!empty($Sel_vproducts))
   {
      $N_products=count($Sel_vproducts);

      for($i=0;$i<$N_products;$i++)
      {
         $prod=$Sel_vproducts[$i];
         list($vLprodPos[$i], $vprodID[$i], $vproduct[$i]) = explode("|", $prod);
         $tipo = $Sel_vcustomerType[$vLprodPos[$i]];
         list($vLcTypePos[$i], $vcTypeID[$i], $vcType[$i]) = explode("|", $tipo);
      }//endfor

   }//endifempty

}//finifproducto

$conexion = conectarse();
$mensaje = "";
$aCliente = chequearCliente($num_cliente, $conexion);
//$mensaje .= $aCliente['error_msg'];
if($aCliente['exist'] == 0)
{
   $aSemana=chequearSemana($fecha, $conexion);
   
   if($aSemana['error'] != 0)
   {
      $mensaje .= $aSemana['error_msg'];
      
      if($aSenana['error'] == -1)
      {
         header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
         return;
      }
   }   //fin if aSemana

   /* INSERTCLIENTE */

   $consulta = "INSERT INTO TClientes(
      CustomerNumber, CompanyName, StartDate, SalesAgent, CreditLimit, Email, MobileNo, Comments) VALUES(
      '$num_cliente', '$company_name', '$fecha', '$agente', '$creditlimit', '$email', '$telefono', '$comment')";
   //echo$consulta;

   $ejecutar_consulta=$conexion->query(utf8_encode($consulta));
   
   if($ejecutar_consulta)
   {
      $mensaje .= "<br>El Cliente con numero <b>$num_cliente</b> ha sido dado de ALTA.";
   }
   else
   {  //error:
      $mensaje .= "<br>NO se pudo dar de ALTA al Cliente con numero <b>$num_cliente</b>";
      $mensaje .= "<br>".$conexion->error;
      header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
      return;
   }  //endifalta

}
else
{  //error:
   $mensaje .= "<br>No se pudo dar de Alta al Cliente con numero <b>$num_cliente</b> por que ya existe.";
   header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
   return;
}//end if Cliente ya existe


if($N_products>0)
{  
   $aCliente = chequearCliente($num_cliente, $conexion);
 
   if ($aCliente['exist'] == 0)
   {
     $mensaje .= "<br> Unexpected Error: No se escuentra el cliente incertado!";
   }

   $ID_semana = $aSemana['ID'];
   $ID_cliente = $aCliente['ID'];

   $consulta = "INSERT INTO TProductoCliente( ID_producto, ID_semana, ID_cliente, ID_CustomerType) VALUES ";

   for($i=0; $i < $N_products; $i++)
   {
       $ID_producto = $vprodID[$i];
       $ID_CustomerType = ($vcTypeID[$i] == -1? 'NULL':$vcTypeID[$i]) ; 
       $consulta .= "('$ID_producto', '$ID_semana', '$ID_cliente',$ID_CustomerType)"; 
       $consulta .= ($i < ($N_products - 1)? ",":";");
   }// end for
      
   $ejecutar_consulta=$conexion->query(utf8_encode($consulta));
   
   if($ejecutar_consulta)
   {
      $mensaje .= "<br>Se ha suscrito a los ".$N_products." productos Correctamente.";
   }
   else
   {  //error:
     $mensaje .= "<br> Error al suscribirse a productos.";
     $mensaje .= "<br>".$conexion->error;

   }

}

$conexion->close();
header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
//include_once("debug/debug_alta_cli_sql.php");
//eof
?>
