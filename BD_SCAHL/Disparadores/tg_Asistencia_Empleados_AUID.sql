CREATE OR REPLACE FUNCTION tf_Asistencia_Empleados_AUID()
RETURNS TRIGGER AS $$
DECLARE
	--
	v_Accion_Antes TEXT;
	v_Accion_Despues TEXT;
	--
BEGIN
	--
    IF TG_OP = 'INSERT' THEN
    	--
		v_Accion_Despues := 'Identif: ' || NEW.Identif
						|| ',Cedula: '  || NEW.Cedula
						|| ',Ingreso: ' || NEW.Ingreso
						|| ',Salida: '  || NEW.Salida
						|| ',Horas_Ex: '|| NEW.Horas_Ex
						|| ',Usua_Cre: '|| NEW.Usua_Cre
						|| ',Usua_Mod: '|| NEW.Usua_Mod;
		--
		INSERT INTO auditoria (
								 Id_Usuario
								,Tabla
								,Accion
								,Info_Antes
								,Info_Desp
								,Fech_Reg
							  )
					   VALUES (
					   			 NEW.Usua_Cre
						   		,'asistencia_empleados'
						   		,'INSERTANDO'
						        ,'N/A'
						   		,v_Accion_Despues
						        ,CURRENT_TIMESTAMP
					          );
		--
	ELSIF TG_OP = 'UPDATE' THEN
    	--
		v_Accion_Antes := 'Identif: ' || OLD.Identif
					  || ',Cedula: '  || OLD.Cedula
					  || ',Ingreso: ' || OLD.Ingreso
					  || ',Salida: '  || OLD.Salida
					  || ',Horas_Ex: '|| OLD.Horas_Ex
					  || ',Usua_Cre: '|| OLD.Usua_Cre
					  || ',Usua_Mod: '|| OLD.Usua_Mod;
		--
		v_Accion_Despues := 'Identif: ' || NEW.Identif
						|| ',Cedula: '  || NEW.Cedula
						|| ',Ingreso: ' || NEW.Ingreso
						|| ',Salida: '  || NEW.Salida
						|| ',Horas_Ex: '|| NEW.Horas_Ex
						|| ',Usua_Cre: '|| NEW.Usua_Cre
						|| ',Usua_Mod: '|| NEW.Usua_Mod;
		--
		INSERT INTO auditoria (
								 Id_Usuario
								,Tabla
								,Accion
								,Info_Antes
								,Info_Desp
								,Fech_Reg
							  )
					   VALUES (
					   			 NEW.Usua_Mod
						   		,'asistencia_empleados'
						   		,'ACTUALIZANDO'
						        ,v_Accion_Antes
						   		,v_Accion_Despues
						        ,CURRENT_TIMESTAMP
					          );
		--
	ELSE
    	--
		v_Accion_Antes := 'Identif: ' || OLD.Identif
					  || ',Cedula: '  || OLD.Cedula
					  || ',Ingreso: ' || OLD.Ingreso
					  || ',Salida: '  || OLD.Salida
					  || ',Horas_Ex: '|| OLD.Horas_Ex
					  || ',Usua_Cre: '|| OLD.Usua_Cre
					  || ',Usua_Mod: '|| OLD.Usua_Mod;
		--
		INSERT INTO auditoria (
								 Id_Usuario
								,Tabla
								,Accion
								,Info_Antes
								,Info_Desp
								,Fech_Reg
							  )
					   VALUES (
					   			 NEW.Usua_Mod
						   		,'asistencia_empleados'
						   		,'BORRANDO'
						        ,v_Accion_Antes
						   		,'N/A'
						        ,CURRENT_TIMESTAMP
					          );
		--
	END IF;
	--
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tg_Asistencia_Empleados_AUID
AFTER INSERT OR UPDATE OR DELETE ON Asistencia_Empleados
FOR EACH ROW
EXECUTE FUNCTION tf_Asistencia_Empleados_AUID()
;