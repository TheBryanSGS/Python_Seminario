--
-- Tabla: Registro
--
-- DROP TABLE IF EXISTS Registro;

CREATE TABLE IF NOT EXISTS Registro
(
    Identif  NUMERIC(7,0)   DEFAULT    NEXTVAL('s_Registros')
   ,Cedula   NUMERIC(11,0)  CONSTRAINT nn_Registro_Cedula    NOT NULL
   ,Ingreso  TIMESTAMPTZ    CONSTRAINT nn_Registro_Ingreso   NOT NULL
   ,Salida   TIMESTAMPTZ    CONSTRAINT nn_Registro_Salida    NOT NULL
   ,Usua_Cre VARCHAR(20)    CONSTRAINT nn_Registro_Usua_Cre  NOT NULL
   ,Usua_Mod VARCHAR(20)
)
TABLESPACE pg_default;
--
ALTER TABLE IF EXISTS public.Registro
    OWNER to postgres;
--
-- Comentarios de la tabla y de las columnas de cada tabla
--
COMMENT ON TABLE  Registro          IS 'Registro de los empleados que ingresan a la empresa';
COMMENT ON COLUMN Registro.Identif  IS 'Identificacion del registro en BD';
COMMENT ON COLUMN Registro.Cedula   IS 'Cedula de un empleado';
COMMENT ON COLUMN Registro.Ingreso  IS 'Ingreso de un empleado, representa la fecha de insercion del registro';
COMMENT ON COLUMN Registro.Salida   IS 'Salida de un empleado, representa la fecha de modificacion del registro';
COMMENT ON COLUMN Registro.Usua_Cre IS 'Usuario que creo el registro';
COMMENT ON COLUMN Registro.Usua_Mod IS 'Usuario que modifico el registro';