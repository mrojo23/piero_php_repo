;
$(document).on("ready",efectosPDB);

function efectosPDB()
{
 	$("#principal form").fadeIn(2000);
}



function showHideCustomerType(cbxlabel, label,select) 
{
    
   if(document.getElementById(cbxlabel).checked) 
   {
       //document.write(cbxlabel+" checked");  
   	   document.getElementById(label).style.display = 'inline';
	     document.getElementById(select).style.display = 'inline';
   } 
   else
   {   document.getElementById(label).style.display = 'none';
       document.getElementById(select).style.display = 'none';
   }
}


