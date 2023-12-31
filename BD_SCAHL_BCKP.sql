PGDMP  $    9                {            DB_SCAHL    16.1    16.1 I               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16396    DB_SCAHL    DATABASE     �   CREATE DATABASE "DB_SCAHL" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';
    DROP DATABASE "DB_SCAHL";
                postgres    false                        3079    16742    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            	           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                       1255    16696    tf_asistencia_empleados_auid()    FUNCTION     �  CREATE FUNCTION public.tf_asistencia_empleados_auid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
					   || ', Cedula: '  || NEW.Cedula
					   || ', Ingreso: ' || TO_CHAR(NEW.Ingreso, 'YYYY-MM-DD HH:MI AM')
					   || ', Salida: '  || COALESCE(TO_CHAR(NEW.Salida, 'YYYY-MM-DD HH:MI AM'), '')
					   || ', Horas_Ex: '|| COALESCE(TO_CHAR(NEW.Horas_Ex, '99'), '')
					   || ', Usua_Cre: '|| NEW.Usua_Cre
					   || ', Usua_Mod: '|| COALESCE(NEW.Usua_Mod, '')
						;
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
						   		,'INS'
						        ,'N/A'
						   		,v_Accion_Despues
						        ,CURRENT_TIMESTAMP
					          );
		--
	ELSIF TG_OP = 'UPDATE' THEN
    	--
		v_Accion_Antes :=   'Identif: ' || OLD.Identif
					   || ', Cedula: '  || OLD.Cedula
					   || ', Ingreso: ' || TO_CHAR(OLD.Ingreso, 'YYYY-MM-DD HH:MI AM')
					   || ', Salida: '  || COALESCE(TO_CHAR(OLD.Salida, 'YYYY-MM-DD HH:MI AM'), '')
					   || ', Horas_Ex: '|| COALESCE(TO_CHAR(OLD.Horas_Ex, '99'), '')
					   || ', Usua_Cre: '|| OLD.Usua_Cre
					   || ', Usua_Mod: '|| COALESCE(OLD.Usua_Mod, '')
					   ;
		--
		v_Accion_Despues := 'Identif: ' || NEW.Identif
					   || ', Cedula: '  || NEW.Cedula
					   || ', Ingreso: ' || TO_CHAR(NEW.Ingreso, 'YYYY-MM-DD HH:MI AM')
					   || ', Salida: '  || TO_CHAR(NEW.Salida, 'YYYY-MM-DD HH:MI AM')
					   || ', Horas_Ex: '|| COALESCE(TO_CHAR(NEW.Horas_Ex, '99'), '')
					   || ', Usua_Cre: '|| NEW.Usua_Cre
					   || ', Usua_Mod: '|| NEW.Usua_Mod
					   ;
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
						   		,'UPD'
						        ,v_Accion_Antes
						   		,v_Accion_Despues
						        ,CURRENT_TIMESTAMP
					          );
		--
	ELSE
    	--
		v_Accion_Antes := 'Identif: ' || OLD.Identif
					 || ', Cedula: '  || OLD.Cedula
					 || ', Ingreso: ' || TO_CHAR(OLD.Ingreso, 'YYYY-MM-DD HH:MI AM')
					 || ', Salida: '  || COALESCE(TO_CHAR(OLD.Salida, 'YYYY-MM-DD HH:MI AM'), '')
					 || ', Horas_Ex: '|| COALESCE(TO_CHAR(OLD.Horas_Ex, '99'), '')
					 || ', Usua_Cre: '|| OLD.Usua_Cre
					 || ', Usua_Mod: '|| COALESCE(OLD.Usua_Mod, '')
					   ;
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
					   			 COALESCE(OLD.Usua_Mod, OLD.Usua_Cre)
						   		,'asistencia_empleados'
						   		,'DEL'
						        ,v_Accion_Antes
						   		,'N/A'
						        ,CURRENT_TIMESTAMP
					          );
		--
	END IF;
	--
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION public.tf_asistencia_empleados_auid();
       public          postgres    false            �            1259    16611    s_asistencia_empleados    SEQUENCE     �   CREATE SEQUENCE public.s_asistencia_empleados
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999
    CACHE 1;
 -   DROP SEQUENCE public.s_asistencia_empleados;
       public          postgres    false            �            1259    16708    asistencia_empleados    TABLE     B  CREATE TABLE public.asistencia_empleados (
    identif numeric(7,0) DEFAULT nextval('public.s_asistencia_empleados'::regclass) NOT NULL,
    cedula numeric(11,0) NOT NULL,
    ingreso timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    salida timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    horas_ex numeric(2,0) DEFAULT 0,
    usua_cre character varying(20) NOT NULL,
    usua_mod character varying(20),
    CONSTRAINT ch_asistencia_empleados_horario CHECK ((ingreso < salida)),
    CONSTRAINT ch_asistencia_empleados_horas_ex CHECK ((horas_ex >= (0)::numeric))
);
 (   DROP TABLE public.asistencia_empleados;
       public         heap    postgres    false    219            
           0    0    TABLE asistencia_empleados    COMMENT     g   COMMENT ON TABLE public.asistencia_empleados IS 'Registro de los empleados que ingresan a la empresa';
          public          postgres    false    221                       0    0 #   COLUMN asistencia_empleados.identif    COMMENT     ^   COMMENT ON COLUMN public.asistencia_empleados.identif IS 'Identificacion del registro en BD';
          public          postgres    false    221                       0    0 "   COLUMN asistencia_empleados.cedula    COMMENT     Q   COMMENT ON COLUMN public.asistencia_empleados.cedula IS 'Cedula de un empleado';
          public          postgres    false    221                       0    0 #   COLUMN asistencia_empleados.ingreso    COMMENT     �   COMMENT ON COLUMN public.asistencia_empleados.ingreso IS 'Ingreso de un empleado, representa la fecha de insercion del registro';
          public          postgres    false    221                       0    0 "   COLUMN asistencia_empleados.salida    COMMENT     �   COMMENT ON COLUMN public.asistencia_empleados.salida IS 'Salida de un empleado, representa la fecha de modificacion del registro';
          public          postgres    false    221                       0    0 $   COLUMN asistencia_empleados.horas_ex    COMMENT     o   COMMENT ON COLUMN public.asistencia_empleados.horas_ex IS 'Horas Extra del empleado, si se llegan a reportar';
          public          postgres    false    221                       0    0 $   COLUMN asistencia_empleados.usua_cre    COMMENT     Z   COMMENT ON COLUMN public.asistencia_empleados.usua_cre IS 'Usuario que creo el registro';
          public          postgres    false    221                       0    0 $   COLUMN asistencia_empleados.usua_mod    COMMENT     ^   COMMENT ON COLUMN public.asistencia_empleados.usua_mod IS 'Usuario que modifico el registro';
          public          postgres    false    221            �            1259    16590    s_auditoria    SEQUENCE     y   CREATE SEQUENCE public.s_auditoria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999
    CACHE 1;
 "   DROP SEQUENCE public.s_auditoria;
       public          postgres    false            �            1259    16591 	   auditoria    TABLE     o  CREATE TABLE public.auditoria (
    identif integer DEFAULT nextval('public.s_auditoria'::regclass) NOT NULL,
    id_usuario character varying(20) NOT NULL,
    tabla character varying(20) NOT NULL,
    accion character varying(3) NOT NULL,
    info_antes text NOT NULL,
    info_desp text NOT NULL,
    fech_reg timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.auditoria;
       public         heap    postgres    false    217                       0    0    TABLE auditoria    COMMENT     i   COMMENT ON TABLE public.auditoria IS 'Registro de las diferentes acciones realizadas a tablas en la BD';
          public          postgres    false    218                       0    0    COLUMN auditoria.identif    COMMENT     V   COMMENT ON COLUMN public.auditoria.identif IS 'Identificacion de la accion en la BD';
          public          postgres    false    218                       0    0    COLUMN auditoria.id_usuario    COMMENT     W   COMMENT ON COLUMN public.auditoria.id_usuario IS 'Id del usuario que hizo la acción';
          public          postgres    false    218                       0    0    COLUMN auditoria.tabla    COMMENT     F   COMMENT ON COLUMN public.auditoria.tabla IS 'Tabla a la cual afecto';
          public          postgres    false    218                       0    0    COLUMN auditoria.accion    COMMENT     f   COMMENT ON COLUMN public.auditoria.accion IS 'Si se hizo una insercion, actualizacion o eliminacion';
          public          postgres    false    218                       0    0    COLUMN auditoria.info_antes    COMMENT     ]   COMMENT ON COLUMN public.auditoria.info_antes IS 'Informacion alterada antes de la acción';
          public          postgres    false    218                       0    0    COLUMN auditoria.info_desp    COMMENT     ]   COMMENT ON COLUMN public.auditoria.info_desp IS 'Informacion alterada despues de la accion';
          public          postgres    false    218                       0    0    COLUMN auditoria.fech_reg    COMMENT     T   COMMENT ON COLUMN public.auditoria.fech_reg IS 'Fecha de realizacion de la accion';
          public          postgres    false    218            �            1259    16623 	   empleados    TABLE     m  CREATE TABLE public.empleados (
    cedula numeric(11,0) NOT NULL,
    nombres character varying(30) NOT NULL,
    apellidos character varying(30) NOT NULL,
    fecha_ingreso date NOT NULL,
    cargo character varying(30) NOT NULL,
    area character varying(3) NOT NULL,
    horas_diarias numeric(2,0)[] NOT NULL,
    salario_base numeric(11,2) NOT NULL,
    nacimiento date NOT NULL,
    direccion character varying(30) NOT NULL,
    estado_civil character varying(1) NOT NULL,
    hijos numeric(2,0) DEFAULT 0,
    email character varying(40) NOT NULL,
    CONSTRAINT ch_empleados_estado_civil CHECK (((estado_civil)::text = ANY ((ARRAY['S'::character varying, 'C'::character varying, 'U'::character varying, 'P'::character varying, 'D'::character varying, 'V'::character varying])::text[]))),
    CONSTRAINT ch_empleados_fecha_ingreso CHECK ((fecha_ingreso <= CURRENT_DATE)),
    CONSTRAINT ch_empleados_nacimiento CHECK ((nacimiento <= (CURRENT_DATE - '18 years'::interval))),
    CONSTRAINT ch_empleados_valid_numer CHECK (((cedula > (1000000)::numeric) AND (salario_base > (1160000)::numeric) AND (hijos >= (0)::numeric)))
);
    DROP TABLE public.empleados;
       public         heap    postgres    false                       0    0    TABLE empleados    COMMENT     {   COMMENT ON TABLE public.empleados IS 'Generalización de una tabla que lleve el registro de los empleados en una empresa';
          public          postgres    false    220                       0    0    COLUMN empleados.cedula    COMMENT     F   COMMENT ON COLUMN public.empleados.cedula IS 'Cedula de un empleado';
          public          postgres    false    220                       0    0    COLUMN empleados.nombres    COMMENT     H   COMMENT ON COLUMN public.empleados.nombres IS 'Nombres de un empleado';
          public          postgres    false    220                       0    0    COLUMN empleados.apellidos    COMMENT     L   COMMENT ON COLUMN public.empleados.apellidos IS 'Apellidos de un empleado';
          public          postgres    false    220                       0    0    COLUMN empleados.fecha_ingreso    COMMENT     U   COMMENT ON COLUMN public.empleados.fecha_ingreso IS 'Fecha de Ingreso a la empresa';
          public          postgres    false    220                       0    0    COLUMN empleados.cargo    COMMENT     C   COMMENT ON COLUMN public.empleados.cargo IS 'Cargo en la empresa';
          public          postgres    false    220                        0    0    COLUMN empleados.area    COMMENT     N   COMMENT ON COLUMN public.empleados.area IS 'Codigo de area en la que labora';
          public          postgres    false    220            !           0    0    COLUMN empleados.horas_diarias    COMMENT     j   COMMENT ON COLUMN public.empleados.horas_diarias IS 'Lista de horas que el empleado realiza a la semana';
          public          postgres    false    220            "           0    0    COLUMN empleados.salario_base    COMMENT     P   COMMENT ON COLUMN public.empleados.salario_base IS 'Salario base del empleado';
          public          postgres    false    220            #           0    0    COLUMN empleados.nacimiento    COMMENT     U   COMMENT ON COLUMN public.empleados.nacimiento IS 'Fecha de nacimiento del empleado';
          public          postgres    false    220            $           0    0    COLUMN empleados.direccion    COMMENT     J   COMMENT ON COLUMN public.empleados.direccion IS 'Direccion del empleado';
          public          postgres    false    220            %           0    0    COLUMN empleados.estado_civil    COMMENT     �   COMMENT ON COLUMN public.empleados.estado_civil IS 'Codigo de estado civil: S-Soltero, C-Casado, U-Union libre, P-Separado, D-Divorciado, V-Viudo';
          public          postgres    false    220            &           0    0    COLUMN empleados.hijos    COMMENT     U   COMMENT ON COLUMN public.empleados.hijos IS 'Numero de Hijos que tiene el empleado';
          public          postgres    false    220            '           0    0    COLUMN empleados.email    COMMENT     O   COMMENT ON COLUMN public.empleados.email IS 'Correo electronico del empleado';
          public          postgres    false    220            �            1259    16555    usuarios    TABLE     �   CREATE TABLE public.usuarios (
    nombre character varying(20) NOT NULL,
    contrasena text NOT NULL,
    permisos character varying(2)[] NOT NULL,
    activo boolean DEFAULT true,
    fech_reg date DEFAULT CURRENT_DATE
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false            (           0    0    TABLE usuarios    COMMENT     @   COMMENT ON TABLE public.usuarios IS 'Registro de los Usuarios';
          public          postgres    false    216            )           0    0    COLUMN usuarios.nombre    COMMENT     J   COMMENT ON COLUMN public.usuarios.nombre IS 'Nombre de usuario asignado';
          public          postgres    false    216            *           0    0    COLUMN usuarios.contrasena    COMMENT     G   COMMENT ON COLUMN public.usuarios.contrasena IS 'Contraseña cifrada';
          public          postgres    false    216            +           0    0    COLUMN usuarios.permisos    COMMENT     ]   COMMENT ON COLUMN public.usuarios.permisos IS 'Codigo de lista de permisos de los usuarios';
          public          postgres    false    216            ,           0    0    COLUMN usuarios.activo    COMMENT     ?   COMMENT ON COLUMN public.usuarios.activo IS 'Usuario activo?';
          public          postgres    false    216            -           0    0    COLUMN usuarios.fech_reg    COMMENT     O   COMMENT ON COLUMN public.usuarios.fech_reg IS 'Fecha de creacion del usuario';
          public          postgres    false    216            �            1259    16733    v_registro_asistencias    VIEW     m  CREATE VIEW public.v_registro_asistencias AS
 SELECT emp.cedula,
    (((emp.nombres)::text || ' '::text) || (emp.apellidos)::text) AS nombre_completo,
    emp.cargo,
    emp.area,
    as_emp.ingreso,
    as_emp.salida,
    as_emp.horas_ex AS horas_extra
   FROM (public.asistencia_empleados as_emp
     JOIN public.empleados emp ON ((as_emp.cedula = emp.cedula)));
 )   DROP VIEW public.v_registro_asistencias;
       public          postgres    false    221    220    220    220    220    221    221    221    220            .           0    0    VIEW v_registro_asistencias    COMMENT     �   COMMENT ON VIEW public.v_registro_asistencias IS 'Consulta que lleva el registro detallado de las asistencias de los empleados';
          public          postgres    false    222            /           0    0 $   COLUMN v_registro_asistencias.cedula    COMMENT     Q   COMMENT ON COLUMN public.v_registro_asistencias.cedula IS 'Cedula del empleado';
          public          postgres    false    222            0           0    0 -   COLUMN v_registro_asistencias.nombre_completo    COMMENT     c   COMMENT ON COLUMN public.v_registro_asistencias.nombre_completo IS 'Nombre completo del empleado';
          public          postgres    false    222            1           0    0 #   COLUMN v_registro_asistencias.cargo    COMMENT     P   COMMENT ON COLUMN public.v_registro_asistencias.cargo IS 'Cargo en la empresa';
          public          postgres    false    222            2           0    0 "   COLUMN v_registro_asistencias.area    COMMENT     P   COMMENT ON COLUMN public.v_registro_asistencias.area IS 'Area en la que opera';
          public          postgres    false    222            3           0    0 %   COLUMN v_registro_asistencias.ingreso    COMMENT     s   COMMENT ON COLUMN public.v_registro_asistencias.ingreso IS 'Fecha de hora de ingreso del empleado en el registro';
          public          postgres    false    222            4           0    0 $   COLUMN v_registro_asistencias.salida    COMMENT     q   COMMENT ON COLUMN public.v_registro_asistencias.salida IS 'Fecha de hora de salida del empleado en el registro';
          public          postgres    false    222            5           0    0 )   COLUMN v_registro_asistencias.horas_extra    COMMENT     _   COMMENT ON COLUMN public.v_registro_asistencias.horas_extra IS 'Horas Extra si llega a tener';
          public          postgres    false    222                      0    16708    asistencia_empleados 
   TABLE DATA           n   COPY public.asistencia_empleados (identif, cedula, ingreso, salida, horas_ex, usua_cre, usua_mod) FROM stdin;
    public          postgres    false    221   �_       �          0    16591 	   auditoria 
   TABLE DATA           h   COPY public.auditoria (identif, id_usuario, tabla, accion, info_antes, info_desp, fech_reg) FROM stdin;
    public          postgres    false    218   J`                 0    16623 	   empleados 
   TABLE DATA           �   COPY public.empleados (cedula, nombres, apellidos, fecha_ingreso, cargo, area, horas_diarias, salario_base, nacimiento, direccion, estado_civil, hijos, email) FROM stdin;
    public          postgres    false    220   �a       �          0    16555    usuarios 
   TABLE DATA           R   COPY public.usuarios (nombre, contrasena, permisos, activo, fech_reg) FROM stdin;
    public          postgres    false    216   �e       6           0    0    s_asistencia_empleados    SEQUENCE SET     D   SELECT pg_catalog.setval('public.s_asistencia_empleados', 3, true);
          public          postgres    false    219            7           0    0    s_auditoria    SEQUENCE SET     9   SELECT pg_catalog.setval('public.s_auditoria', 6, true);
          public          postgres    false    217            g           2606    16715 3   asistencia_empleados pk_asistencia_empleado_identif 
   CONSTRAINT     v   ALTER TABLE ONLY public.asistencia_empleados
    ADD CONSTRAINT pk_asistencia_empleado_identif PRIMARY KEY (identif);
 ]   ALTER TABLE ONLY public.asistencia_empleados DROP CONSTRAINT pk_asistencia_empleado_identif;
       public            postgres    false    221            c           2606    16606    auditoria pk_auditoria_identif 
   CONSTRAINT     a   ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT pk_auditoria_identif PRIMARY KEY (identif);
 H   ALTER TABLE ONLY public.auditoria DROP CONSTRAINT pk_auditoria_identif;
       public            postgres    false    218            e           2606    16630    empleados pk_empleados_cedula 
   CONSTRAINT     _   ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT pk_empleados_cedula PRIMARY KEY (cedula);
 G   ALTER TABLE ONLY public.empleados DROP CONSTRAINT pk_empleados_cedula;
       public            postgres    false    220            a           2606    16622    usuarios pk_usuarios_nombre 
   CONSTRAINT     ]   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_usuarios_nombre PRIMARY KEY (nombre);
 E   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT pk_usuarios_nombre;
       public            postgres    false    216            l           2620    16740 1   asistencia_empleados tg_asistencia_empleados_auid    TRIGGER     �   CREATE TRIGGER tg_asistencia_empleados_auid AFTER INSERT OR DELETE OR UPDATE ON public.asistencia_empleados FOR EACH ROW EXECUTE FUNCTION public.tf_asistencia_empleados_auid();
 J   DROP TRIGGER tg_asistencia_empleados_auid ON public.asistencia_empleados;
       public          postgres    false    221    270            i           2606    16726 3   asistencia_empleados fk_asistencia_empleados_cedula    FK CONSTRAINT     �   ALTER TABLE ONLY public.asistencia_empleados
    ADD CONSTRAINT fk_asistencia_empleados_cedula FOREIGN KEY (cedula) REFERENCES public.empleados(cedula);
 ]   ALTER TABLE ONLY public.asistencia_empleados DROP CONSTRAINT fk_asistencia_empleados_cedula;
       public          postgres    false    221    220    4709            j           2606    16716 5   asistencia_empleados fk_asistencia_empleados_usua_ins    FK CONSTRAINT     �   ALTER TABLE ONLY public.asistencia_empleados
    ADD CONSTRAINT fk_asistencia_empleados_usua_ins FOREIGN KEY (usua_cre) REFERENCES public.usuarios(nombre);
 _   ALTER TABLE ONLY public.asistencia_empleados DROP CONSTRAINT fk_asistencia_empleados_usua_ins;
       public          postgres    false    221    216    4705            k           2606    16721 5   asistencia_empleados fk_asistencia_empleados_usua_mod    FK CONSTRAINT     �   ALTER TABLE ONLY public.asistencia_empleados
    ADD CONSTRAINT fk_asistencia_empleados_usua_mod FOREIGN KEY (usua_mod) REFERENCES public.usuarios(nombre);
 _   ALTER TABLE ONLY public.asistencia_empleados DROP CONSTRAINT fk_asistencia_empleados_usua_mod;
       public          postgres    false    221    216    4705            h           2606    16668 !   auditoria fk_auditoria_id_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT fk_auditoria_id_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuarios(nombre);
 K   ALTER TABLE ONLY public.auditoria DROP CONSTRAINT fk_auditoria_id_usuario;
       public          postgres    false    218    216    4705               �   x�u�1�0��99H�g�v쳰�J��@造�f�?�(`j>�0�4p]0SFB�0Ә���2�Z�w7�����~[�e[_C��M�0>���$�a,"gI��N6���- �8m)�y��}������+������ �>!      �   F  x�Ŕ�j�0E��W�8�fd�fW�B�H��
A�J0�q���W}��P\L�t���0	�m݄�N|[��px��&<��/�6�-V���6���p����4����K���ƺf�]ښ��	�Ͳ��<���We<��C��vs��  2X�'��6���}o^�IOmc�y��rv"TJC���Y�U!	/���j4t�X��i�Rv�������i�hY�s��A�q|�ӓ"��Ln��lc1��k��(M�E�d#F)&̅�J��F5t�d/�D]�/�*f�������T���C�CpM�Q�~/�0H���ABm4ƞ���<M�7�J�1           x����V�8���S���$����@�L�н�Ma��n���6gsx�~�~�)�/N�bHV�~�u�
.�(Nfi���
������ݻ�e�d� �>�>�a!+��h����mS*c��r�rv>�������1�Y�|�����!���RvN��E���lϲt��Q(8ܣU�]��)��l�i���	}�ܔ�CA��y8���(�	E�,u]��R���a�N(�8�	H�Q�aHv�Hae���j����fpG��J���x`q����M<�'�R" C�E��`vN-��̄�s.�pD%z�=pgv��W��ZZ�`��"_İ$c�CX.��MǓ��͸�ʪ2W;�dNXb���tFY���l6s��T�lj%�͕���-��:�jU���{����V=�F'm��|��m
}6s����yS��]�� � J��0I�Æ^`��F��Z�}���o�E��
mKz��ˎ�}���o��2?bMk_)Nک�^eD�1A��]I�v��-ѡxs�jI�U�5�\M�n����m�פ���8�"�)�����-D�:�OH	�`iưFrnm^��m(�j���/�y�?��n�JAsٛ8�����ߊ̬�t����V���n����lJ̕�G�*�µ���#����4���~9�K�d�E>K|������R]�Z��4&8�m}�T�,uߟ=L��M8�ϕ5/�R���t�a<	[�0�����rP��I�v]A[ w�4la�[SQ!�͕�]�ǅ��{r��m��WO'l�%�l������b�i��&@��r�ѻ��Q��ոߤ��F����ȕ뻱��y�^��p���k�_g�+��+�V4x�$�]�i�@^5glt_��p��e�����+߅���?�]u���4g���H������,-��mWc�o��U�[Q������T���C���1����~q>yS9������|�~kj����V�p�~��oxF���[O�V��h��?6�a��k��f:�~D����}�������      �   �   x�m��N�0  �3<GWYa#Mƀ��L�xi�P6(���0����.��>�ԃdr�HskЄ?�A�ULhe�;>L�>��d��n�h)���:��}@���w־B�[5hBk�����Wñ�`�-�M�쵓�X_,�
���u��K-k��]���-F7�N/S�OL��8�D���OO�ev���^�cr� o�|�(L���Y?_e���\x�����߀��?�SB     