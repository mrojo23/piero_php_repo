<form id="alta-cliente" name="alta_cliente_frm" action="php/alta-cliente-sql.php" method="post" enctype="multipart/form-data">
	<fieldset>
		<legend>Alta de Cliente</legend>
		<div>
			<label for="numero">Customer Number: </label>
			<input type="text" id= "num_cliente" class="cambio" name="num_cliente_txt" placeholder="Numero de Cliente" title ="Numero de identificacion del Cliente" required/>
		</div>
		<div>
			<label for="nombre">Company Name: </label>
			<input type="text" id= "company_name" class="cambio" name="company_name_txt" placeholder="Nombre de la Compañia" title ="Introduce aqui el nombre de la Compañia" required/>
		</div>
		<div>
		    <?php $fecha=date('Y-m-d');?>
			<label for="fecha">Fecha de Alta: </label>
			<input type="date" id= "fecha" class="cambio" name="fecha_txt" value= <?php echo '"'.$fecha.'"'; ?>placeholder="Fecha de Alta" title ="Introduce aqui la fecha de Alta" required/>
		</div> 
		<div>
			<label for="agent">Sales Agent: </label>
			<input type="text" id= "agente" class="cambio" name="agente_txt" placeholder="Agente de ventas" title ="Introduce aqui el Agente de ventas"/>
		</div>
		<div>
			<label for="email">Email: </label>
			<input type="email" id= "email" class="cambio" name="email_txt" placeholder="Email del Cliente" title ="Introduce aqui el email del cliente"/>
		</div>
		<div>
			<label for="telefono">Telefono: </label>
			<input type="text" id= "telefono" class="cambio" name="telefono_txt" placeholder="numero de telefono" title ="Añadir numero de contacto del Cliente"/>
		</div>
		<div>
			<label> Productos :</label>
		</div>
		    <?php include("select-customertype.php"); ?>
		<div>
			<label for="grupo">Ref.: </label>
			<select id= "grupo" class="cambio" name="grupo_sel" title ="Asignar grupo">
			<option value="">- - -</option>
			<?php include("select-grupo.php"); ?>
			</select>
		</div>
		<div>
			<label for="creditlimit">Credit Limit: </label>
			<input type="number" id= "creditlimit" class="cambio" name="creditlimit_num" min="0" step="50"  placeholder="limite de credito" title ="Establecer limite de Credito"/>
		    <label>  €</label>
		</div>
		<div>
			<label for="stop">Stop: </label>
			<input type="checkbox" id= "stop" class="cambio" name="stop_cbx" title ="Bloquear Cliente" value="yes" />
		</div>
		<div>
			<label for="comment">Comentario:</label>
		</div>
		<div>
			<textarea rows="10" cols="90" id= "comment" name="comment_txa" placeholder="(Añadir comentario)" title ="Escribe aqui algun comentario sobre el cliente"></textarea>
		</div>
		<div>
			<input type="submit" id="enviar-alta" class="cambio" name="enviar_btn" value="agregar" />
		</div>
		 <?php include("php/mensajes.php"); ?>
	</fieldset>
</form>