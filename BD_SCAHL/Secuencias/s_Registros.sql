--
-- SEQUENCE: s_Registros
--
-- DROP SEQUENCE IF EXISTS s_Registros;

CREATE SEQUENCE IF NOT EXISTS ps_Registros
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999
    ;

ALTER SEQUENCE s_Registros
    OWNER TO postgres;