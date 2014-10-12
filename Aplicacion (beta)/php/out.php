<?php

//GUARDARDATOSENVARIABLES///////////////////////////////////////////////////////////

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
list($vLprodPos[$i],$vprodID[$i],$vproduct[$i])=explode("|",$prod);
$tipo=$Sel_vcustomerType[$LprodPos[$i]];
list($vLcTypePos[$i],$vcTypeID[$i],$vcType[$i])=explode("|",$tipo);

}//endfor

}//endifempty

}//finifproducto


//ALTACLIENTE//////////////////////////////////////////////////////////////////////


include_once("checkear_datos.php");

include_once("conexion.php");
$conexion=conectarse();
//$consulta="SELECT*FROMTClientesWHERECustomerNumber='$num_cliente'";

$mensaje="";

$aCliente=chequearCliente($num_cliente,$conexion);

if($aCliente['exist']==0)
{
$aSemana=chequearSemana($fecha);
if($aSenana['error']!=0)
{
$mensaje.=$aSenana['error_msg'];
if($aSenana['error']==-1)
{
header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
}
}

//INSERTCLIENTE--------------------------------------------------------------------------------------
$consulta="INSERTINTOTClientes(
CustomerNumber,CompanyName,StartDate,SalesAgent,CreditLimit,Email,MobileNo,Comments)VALUES(
'$num_cliente','$company_name','$fecha','$agente','$creditlimit','$email','$telefono','$comment')";
//echo$consulta;
$ejecutar_consulta=$conexion->query(utf8_encode($consulta));
//______________________________________________________________________________________________________
if($ejecutar_consulta)
{
$mensaje.="<br>ElClienteconnumero<b>$num_cliente</b>hasidodadodeALTA.";
}
else
{//error:
$mensaje.="<br>NOsepudodardeALTAalClienteconnumero<b>$num_cliente</b>";
$mensaje.="<br>".$conexion->error;
header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
}//endifalta

}
else
{//error:
$mensaje.="<br>NosepudodardeAltaalClienteconnumero<b>$num_cliente</b>porqueyaexiste.";
$ejecutar_consulta->close();
header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
}//endifyaexiste

}//finifejecutarconsulta



//RegistrarClienteaProductos//////////////////////////////////////////////////////////////

/*

$ID_producto;
$ID_semana;[ID_ano,Nsemana]
$ID_cliente;
$ID_CustomerType;
			-Silaternacli-sem-prodexiste->elclienteestasuscritoalprodesasemana.
			-Customertyeseltipodeclienteparaeseproductoesasemana.
			-SicustomertypeesNull,seconsideraatencionpersonal.
*/







/*if($N_products>0)
{
for($i=0;$i<$N_products;$i++)
{

}

}

*/



$conexion->close();
//header("Location:../index.php?m=clientes&op=alta_cliente&mensaje=$mensaje");
//include_once("debug/debug_alta_cli_sql.php");
//eof
?>
