<?php
include_once("conexion.php");
$conexion = conectarse();

$consulta1="SELECT * FROM Tproducto ORDER BY Producto";

if ($ejecutar_consulta1 = $conexion->query($consulta1))
{

   $n=0;

   while ($registro1 = $ejecutar_consulta1->fetch_assoc()) 
   {
	    $Prod_ID=$registro1["ID"];
	    $producto=$registro1["Producto"];
	
	    $consulta2="SELECT * FROM tcustomertype  WHERE ID_producto = ".$Prod_ID." ORDER BY CustomerType";
      
      if($ejecutar_consulta2 = $conexion->query($consulta2))
	    {
	       $checkboxHide = "<input type='checkbox' id= 'prod".$n."cbx' class='cambio' name= 'producto[]' value = '".$n."|".$Prod_ID."|".$producto."' style='margin-left:2.5em;' title ='Seleccionar producto ".$producto."'";

         if($ejecutar_consulta2->num_rows > 0)
         {
            $checkboxHide .= " onclick=\"showHideCustomerType('prod".$n."cbx','lcustypeprod".$n."','custypeprod".$n."')\" />"; 
         }
         else
         {
            $checkboxHide .= " />";
         }
	
	       echo "<div>";
           echo $checkboxHide; 
	         echo "<label for='prod".$n."cbx' style='padding-left:.3em;' >".$producto." </label>";
           echo "<label for='custypeprod".$n."' id='lcustypeprod".$n."' style='display:none;padding-left:0.5em;'> tipo: </label>";
	         echo "<select id= 'custypeprod".$n."' class='cambio' name='customerType[]' value ='".$n."' title ='Establecer el tipo de Cliente' style='display:none;' >";
	            echo "<option value='".$n."|-1|Atencion Personal'>(Atencion Personal)</option>";
	      
              while ($registro2 = $ejecutar_consulta2->fetch_assoc()) 
              {
                 $cType_ID=$registro2["ID"];
	               $cType=$registro2["CustomerType"];
	               echo "<option value='".$n."|".$cType_ID."|".$cType."'>".$registro2["CustomerType"]."</option>";
              }//fin while

           echo "</select>";
         echo "</div>";
         $ejecutar_consulta2->close();

      }// fin if  $ejecutar_consulta2

      $n+=1;

    }//fin while

    $ejecutar_consulta1->close();

} // fin if  $ejecutar_consulta1   

$conexion->close();

//eof
?>
