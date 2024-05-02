--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5 (Debian 15.5-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: serverhost; Type: SCHEMA; Schema: -; Owner: Sentinel
--

CREATE SCHEMA serverhost;


ALTER SCHEMA serverhost OWNER TO "Sentinel";

--
-- Name: sgbd; Type: SCHEMA; Schema: -; Owner: Sentinel
--

CREATE SCHEMA sgbd;


ALTER SCHEMA sgbd OWNER TO "Sentinel";

--
-- Name: stage; Type: SCHEMA; Schema: -; Owner: Sentinel
--

CREATE SCHEMA stage;


ALTER SCHEMA stage OWNER TO "Sentinel";

--
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;


--
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- Name: sp_insert_instancia_pg(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_insert_instancia_pg()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.instancia_pg(idinstancia, name, setting, unit, category)
	SELECT DISTINCT
	       A.idinstancia, A.name, A.setting, A.unit, A.category
	FROM stage.instancia_pg A
	LEFT JOIN sgbd.instancia_pg B ON B.idinstancia = A.idinstancia
								 AND A.name    = B.name
								 AND A.setting = B.setting	   
	WHERE B.idinstancia IS NULL;
	
	TRUNCATE TABLE stage.instancia_pg;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_insert_instancia_pg() OWNER TO "Sentinel";

--
-- Name: sp_insert_login(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_insert_login()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.logins(idinstancia, loginname, tipo_login)
	SELECT A.idinstancia, A.loginname, A.tipo_login
	FROM stage.logins A
	LEFT JOIN sgbd.logins B ON B.idinstancia = A.idinstancia
								 AND A.loginname     = B.loginname
	WHERE B.idinstancia IS NULL;
	
	TRUNCATE TABLE stage.logins;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_insert_login() OWNER TO "Sentinel";

--
-- Name: sp_insert_logins_database(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_insert_logins_database()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.logins_database(idlogins, acessement, tipo_login)
	SELECT DISTINCT B.idlogins, A.acessement, A.tipo_login
	FROM stage.logins_database A
	INNER JOIN sgbd.logins B          ON B.idinstancia = A.idinstancia AND B.loginname = A.loginname
	LEFT JOIN  sgbd.logins_database C ON C.idlogins    = B.idlogins AND C.acessement = A.acessement
	WHERE C.idlogins IS  NULL;
	
	TRUNCATE TABLE stage.logins_database;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_insert_logins_database() OWNER TO "Sentinel";

--
-- Name: sp_insert_logins_instancia(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_insert_logins_instancia()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.logins_instancia(idlogins, acessement, tipo_login)
	SELECT DISTINCT B.idlogins, A.acessement, A.tipo_login
	FROM stage.logins_instancia A
	INNER JOIN sgbd.logins B           ON B.idinstancia = A.idinstancia AND B.loginname = A.loginname
	LEFT JOIN  sgbd.logins_instancia C ON C.idlogins    = B.idlogins AND C.acessement = A.acessement
	WHERE C.idlogins IS NULL;
	
	TRUNCATE TABLE stage.logins_instancia;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_insert_logins_instancia() OWNER TO "Sentinel";

--
-- Name: sp_pg_insert_bdtabela(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_pg_insert_bdtabela()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.bdtabela(
			 idbasededados,   schema_name,   table_name) 
	SELECT A.idbasededados, A.schema_name, A.table_name
	FROM stage.bdtabela A
	LEFT JOIN sgbd.bdtabela B ON B.idbasededados = A.idbasededados
	WHERE B.idbasededados IS NULL;

	TRUNCATE TABLE stage.basededados;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_pg_insert_bdtabela() OWNER TO "Sentinel";

--
-- Name: sp_pg_insert_database(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_pg_insert_database()
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO sgbd.basededados
			(idinstancia,   idtrilha,   basededados,   dbowner,   descricao,   created)
	SELECT A.idinstancia, A.idtrilha, A.basededados, A.dbowner, A.descricao, A.created
	FROM stage.basededados A
	LEFT JOIN sgbd.basededados B ON B.idinstancia = A.idinstancia
	WHERE B.idinstancia IS NULL;
	
	TRUNCATE TABLE stage.basededados;
	
end; 
$$;


ALTER PROCEDURE sgbd.sp_pg_insert_database() OWNER TO "Sentinel";

--
-- Name: sp_pg_insert_database_tamanho(integer, character varying, numeric); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_pg_insert_database_tamanho(IN v_idinstancia integer, IN v_basededados character varying, IN v_tamanho numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Selecione os dados com base nos parâmetros fornecidos
  INSERT INTO sgbd.bdtamanho(idbasededados, tamanho)
  SELECT BT.idbasededados, v_tamanho
  FROM sgbd.vw_basededados BT
  WHERE BT.idinstancia = v_idinstancia
    AND BT.basededados = v_basededados
    AND BT.tamanho <> v_tamanho;
END;
$$;


ALTER PROCEDURE sgbd.sp_pg_insert_database_tamanho(IN v_idinstancia integer, IN v_basededados character varying, IN v_tamanho numeric) OWNER TO "Sentinel";

--
-- Name: sp_pg_insert_tbcoluna(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_pg_insert_tbcoluna()
    LANGUAGE plpgsql
    AS $$
BEGIN

	INSERT INTO sgbd.tbcoluna(idbdtabela, colunn_name, ordenal_positon, data_type)
	SELECT DISTINCT
		   tb.idbdtabela
		 , st.colunn_name
		 , st.ordenal_positon
		 , st.data_type
	FROM stage.tbcoluna st
	INNER JOIN sgbd.bdtabela tb ON tb.idbasededados = st.idbasededados 
							   AND tb.schema_name   = st.schema_name
							   AND tb.table_name    = st.table_name
	LEFT JOIN sgbd.tbcoluna cl ON cl.idbdtabela     = tb.idbdtabela
							  AND cl.colunn_name    = st.colunn_name
							  AND cl.data_type      = st.data_type
	WHERE cl.idbdtabela IS NULL;
	
	TRUNCATE TABLE stage.tbcoluna;
END;
$$;


ALTER PROCEDURE sgbd.sp_pg_insert_tbcoluna() OWNER TO "Sentinel";

--
-- Name: sp_pg_insert_tbindex(); Type: PROCEDURE; Schema: sgbd; Owner: Sentinel
--

CREATE PROCEDURE sgbd.sp_pg_insert_tbindex()
    LANGUAGE plpgsql
    AS $$
BEGIN

	INSERT INTO sgbd.tbindex(idbdtabela, index_name, index_type)
	SELECT DISTINCT tb.idbdtabela, st.index_name, st.index_type
	FROM stage.tbindex st
	LEFT JOIN sgbd.bdtabela tb ON tb.idbasededados = st.idbasededados 
							   AND RTRIM(LTRIM(tb.schema_name))   = RTRIM(LTRIM(st.schemaname))
							   AND RTRIM(LTRIM(tb.table_name))    = RTRIM(LTRIM(st.tablename))
	LEFT JOIN sgbd.tbindex ti   ON ti.idbdtabela    = tb.idbdtabela
							   AND RTRIM(LTRIM(ti.index_name))    = RTRIM(LTRIM(st.index_name))
	WHERE tb.idbdtabela IS NOT NULL;
	
	TRUNCATE TABLE stage.tbindex;
	
END;
$$;


ALTER PROCEDURE sgbd.sp_pg_insert_tbindex() OWNER TO "Sentinel";

--
-- Name: rm_sentineldatasuite; Type: SERVER; Schema: -; Owner: Sentinel
--

CREATE SERVER rm_sentineldatasuite FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'SentinelDataSuite',
    host '10.0.19.140',
    port '5433'
);


ALTER SERVER rm_sentineldatasuite OWNER TO "Sentinel";

--
-- Name: USER MAPPING Sentinel SERVER rm_sentineldatasuite; Type: USER MAPPING; Schema: -; Owner: Sentinel
--

CREATE USER MAPPING FOR "Sentinel" SERVER rm_sentineldatasuite OPTIONS (
    password 'Sentinel',
    "user" 'Sentinel'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: instancia; Type: TABLE; Schema: public; Owner: Sentinel
--

CREATE TABLE public.instancia (
    idinstancia integer,
    idshservidor integer,
    idtrilha integer,
    idcluster character varying(50),
    instancia character varying(50),
    sgbd character varying(50),
    ip character varying(50),
    regiao character varying(50),
    dependencia character varying(50),
    adsite character varying(50),
    conectstring character varying(50),
    porta integer,
    "Cluster" integer,
    versao character varying(50),
    productversion character varying(50),
    descricao character varying(50),
    funcaoserver character varying(128),
    sobreadministracao character varying(128),
    memoryconfig character varying(50),
    cpu character varying(50),
    estanciaativo integer,
    startinstancia character varying(50),
    dhcriacao character varying(50),
    dhalteracao character varying(50)
);


ALTER TABLE public.instancia OWNER TO "Sentinel";

--
-- Name: serverdb; Type: FOREIGN TABLE; Schema: serverhost; Owner: Sentinel
--

CREATE FOREIGN TABLE serverhost.serverdb (
    id_serverhost integer,
    id_trilha integer,
    trilha character varying(60),
    sigla character varying(10),
    hostname character varying(60),
    dep character varying(20),
    regiao character varying(20),
    estado character varying(20),
    unidade text,
    fisicovm character varying(20),
    sistemaoperaciona character varying(200),
    ipaddress character varying(250),
    portconect character varying(10),
    descricao text,
    versao character varying(350),
    cpu bigint,
    memoryram bigint,
    ad boolean,
    or_ad boolean,
    sccm boolean,
    or_sccm boolean,
    nx boolean,
    or_nx boolean,
    vw boolean,
    or_vw boolean,
    dhcriacao timestamp without time zone,
    dhalteracao timestamp without time zone,
    ativo boolean
)
SERVER rm_sentineldatasuite
OPTIONS (
    schema_name 'inventario',
    table_name 'vw_serverhost'
);


ALTER FOREIGN TABLE serverhost.serverdb OWNER TO "Sentinel";

--
-- Name: trilha; Type: FOREIGN TABLE; Schema: serverhost; Owner: Sentinel
--

CREATE FOREIGN TABLE serverhost.trilha (
    id_trilha integer,
    trilha character varying(60),
    sigla character varying(10)
)
SERVER rm_sentineldatasuite
OPTIONS (
    schema_name 'inventario',
    table_name 'trilha'
);


ALTER FOREIGN TABLE serverhost.trilha OWNER TO "Sentinel";

--
-- Name: basededados_idbasededados_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.basededados_idbasededados_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.basededados_idbasededados_seq OWNER TO "Sentinel";

--
-- Name: basededados; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.basededados (
    idbasededados integer DEFAULT nextval('sgbd.basededados_idbasededados_seq'::regclass) NOT NULL,
    idinstancia integer NOT NULL,
    idtrilha integer,
    basededados character varying(150),
    dbowner character varying(100),
    descricao character varying(255),
    created timestamp without time zone,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);


ALTER TABLE sgbd.basededados OWNER TO "Sentinel";

--
-- Name: bdtabela_idbdtabela_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.bdtabela_idbdtabela_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.bdtabela_idbdtabela_seq OWNER TO "Sentinel";

--
-- Name: bdtabela; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.bdtabela (
    idbdtabela integer DEFAULT nextval('sgbd.bdtabela_idbdtabela_seq'::regclass) NOT NULL,
    idbasededados integer NOT NULL,
    schema_name character varying(128),
    table_name character varying(128),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);


ALTER TABLE sgbd.bdtabela OWNER TO "Sentinel";

--
-- Name: bdtamanho_idbdtamanho_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.bdtamanho_idbdtamanho_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.bdtamanho_idbdtamanho_seq OWNER TO "Sentinel";

--
-- Name: bdtamanho; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.bdtamanho (
    idbdtamanho integer DEFAULT nextval('sgbd.bdtamanho_idbdtamanho_seq'::regclass) NOT NULL,
    idbasededados integer NOT NULL,
    tamanho real,
    datatimer timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE sgbd.bdtamanho OWNER TO "Sentinel";

--
-- Name: cluster_idcluster_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.cluster_idcluster_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.cluster_idcluster_seq OWNER TO "Sentinel";

--
-- Name: cluster; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.cluster (
    idcluster integer DEFAULT nextval('sgbd.cluster_idcluster_seq'::regclass) NOT NULL,
    idclustertipo integer,
    clustername character varying(60),
    ip character varying(50),
    ativo boolean DEFAULT true,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);


ALTER TABLE sgbd.cluster OWNER TO "Sentinel";

--
-- Name: clusterno_idclusterno_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.clusterno_idclusterno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.clusterno_idclusterno_seq OWNER TO "Sentinel";

--
-- Name: clusterno; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.clusterno (
    idclusterno integer DEFAULT nextval('sgbd.clusterno_idclusterno_seq'::regclass) NOT NULL,
    id_serverhost integer NOT NULL,
    idcluster integer NOT NULL,
    ativo boolean DEFAULT true
);


ALTER TABLE sgbd.clusterno OWNER TO "Sentinel";

--
-- Name: clustertipo_idclustertipo_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.clustertipo_idclustertipo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.clustertipo_idclustertipo_seq OWNER TO "Sentinel";

--
-- Name: clustertipo; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.clustertipo (
    idclustertipo integer DEFAULT nextval('sgbd.clustertipo_idclustertipo_seq'::regclass) NOT NULL,
    tipo character varying(50)
);


ALTER TABLE sgbd.clustertipo OWNER TO "Sentinel";

--
-- Name: instancia_idinstancia_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.instancia_idinstancia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.instancia_idinstancia_seq OWNER TO "Sentinel";

--
-- Name: instancia; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.instancia (
    idinstancia integer DEFAULT nextval('sgbd.instancia_idinstancia_seq'::regclass) NOT NULL,
    id_serverhost integer NOT NULL,
    id_trilha integer NOT NULL,
    idcluster integer,
    instancia character varying(255),
    sgbd character varying(30),
    ip character varying(255),
    conectstring character varying(255),
    porta real,
    cluster boolean DEFAULT false,
    versao character varying(255),
    productversion character varying(255),
    descricao character varying(255),
    funcaoserver character(100),
    sobreadministracao character(100),
    memoryconfig numeric(18,2),
    cpu integer,
    estanciaativo boolean DEFAULT true,
    startinstancia timestamp without time zone,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true,
    status_bd character varying(50)
);


ALTER TABLE sgbd.instancia OWNER TO "Sentinel";

--
-- Name: instancia_pg_seq_instancia_pg_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.instancia_pg_seq_instancia_pg_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.instancia_pg_seq_instancia_pg_seq OWNER TO "Sentinel";

--
-- Name: instancia_pg; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.instancia_pg (
    idinstancia_pg integer DEFAULT nextval('sgbd.instancia_pg_seq_instancia_pg_seq'::regclass) NOT NULL,
    idinstancia integer NOT NULL,
    name text,
    setting text,
    unit text,
    category text,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);


ALTER TABLE sgbd.instancia_pg OWNER TO "Sentinel";

--
-- Name: logins_idlogins_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.logins_idlogins_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.logins_idlogins_seq OWNER TO "Sentinel";

--
-- Name: logins; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.logins (
    idlogins integer DEFAULT nextval('sgbd.logins_idlogins_seq'::regclass) NOT NULL,
    idinstancia integer NOT NULL,
    loginname character varying(128),
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);


ALTER TABLE sgbd.logins OWNER TO "Sentinel";

--
-- Name: logins_database_idloginsdb_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.logins_database_idloginsdb_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.logins_database_idloginsdb_seq OWNER TO "Sentinel";

--
-- Name: logins_database; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.logins_database (
    idloginsdb integer DEFAULT nextval('sgbd.logins_database_idloginsdb_seq'::regclass) NOT NULL,
    idlogins integer NOT NULL,
    acessement jsonb,
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);


ALTER TABLE sgbd.logins_database OWNER TO "Sentinel";

--
-- Name: logins_instancia_idloginsin_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.logins_instancia_idloginsin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.logins_instancia_idloginsin_seq OWNER TO "Sentinel";

--
-- Name: logins_instancia; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.logins_instancia (
    idloginsin integer DEFAULT nextval('sgbd.logins_instancia_idloginsin_seq'::regclass) NOT NULL,
    idlogins integer NOT NULL,
    acessement jsonb,
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);


ALTER TABLE sgbd.logins_instancia OWNER TO "Sentinel";

--
-- Name: tbcoluna_idtbcoluna_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.tbcoluna_idtbcoluna_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.tbcoluna_idtbcoluna_seq OWNER TO "Sentinel";

--
-- Name: tbcoluna; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.tbcoluna (
    idtbcoluna integer DEFAULT nextval('sgbd.tbcoluna_idtbcoluna_seq'::regclass) NOT NULL,
    idbdtabela integer NOT NULL,
    colunn_name character varying(128),
    ordenal_positon integer,
    data_type character varying(128),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);


ALTER TABLE sgbd.tbcoluna OWNER TO "Sentinel";

--
-- Name: tbindex_idtbindex_seq; Type: SEQUENCE; Schema: sgbd; Owner: Sentinel
--

CREATE SEQUENCE sgbd.tbindex_idtbindex_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sgbd.tbindex_idtbindex_seq OWNER TO "Sentinel";

--
-- Name: tbindex; Type: TABLE; Schema: sgbd; Owner: Sentinel
--

CREATE TABLE sgbd.tbindex (
    idtbindex integer DEFAULT nextval('sgbd.tbindex_idtbindex_seq'::regclass) NOT NULL,
    idbdtabela integer NOT NULL,
    index_name character varying(255),
    index_type character varying(255),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);


ALTER TABLE sgbd.tbindex OWNER TO "Sentinel";

--
-- Name: vw_instancia; Type: VIEW; Schema: sgbd; Owner: Sentinel
--

CREATE VIEW sgbd.vw_instancia AS
 SELECT s.idinstancia,
    sh.id_serverhost,
    s.id_trilha,
    sh.sigla,
    upper((
        CASE
            WHEN ((s.cluster = true) AND ((s.instancia)::text = 'NULL'::text) AND ((s.sgbd)::text = 'MS SQL Server'::text)) THEN cl.clustername
            WHEN ((s.cluster = true) AND ((s.instancia)::text <> 'NULL'::text) AND ((s.sgbd)::text = 'MS SQL Server'::text)) THEN ((((cl.clustername)::text || '\'::text) || (s.instancia)::text))::character varying
            WHEN ((s.cluster = false) AND (((s.instancia)::text = ''::text) OR ((s.instancia)::text = 'NULL'::text)) AND ((s.sgbd)::text = 'MS SQL Server'::text)) THEN sh.hostname
            WHEN ((s.cluster = false) AND ((s.instancia)::text <> 'NULL'::text) AND ((s.sgbd)::text = 'MS SQL Server'::text)) THEN ((((sh.hostname)::text || '\'::text) || (s.instancia)::text))::character varying
            WHEN ((s.cluster = false) AND (((s.instancia)::text = ''::text) OR ((s.instancia)::text <> 'NULL'::text)) AND ((s.sgbd)::text <> 'MS SQL Server'::text)) THEN sh.hostname
            ELSE NULL::character varying
        END)::text) AS servidor,
    upper((sh.hostname)::text) AS hostname,
    s.instancia,
    s.sgbd,
    s.ip,
    sh.regiao,
    sh.dep,
    sh.estado,
    s.conectstring,
    (s.porta)::integer AS databseporta,
    sh.portconect AS "remotPort",
    s.cluster,
    s.memoryconfig,
    s.cpu,
    s.versao,
    s.productversion,
    s.descricao,
    sh.dhcriacao,
    sh.dhalteracao,
    s.funcaoserver,
    s.sobreadministracao,
    s.ativo AS status_instancia,
    s.startinstancia,
    CURRENT_DATE AS dt_execucao
   FROM ((sgbd.instancia s
     JOIN serverhost.serverdb sh ON ((sh.id_serverhost = s.id_serverhost)))
     LEFT JOIN sgbd.cluster cl ON ((cl.idcluster = s.idcluster)));


ALTER VIEW sgbd.vw_instancia OWNER TO "Sentinel";

--
-- Name: vw_basededados; Type: VIEW; Schema: sgbd; Owner: Sentinel
--

CREATE VIEW sgbd.vw_basededados AS
 SELECT i.idinstancia,
    i.id_serverhost,
    b.idbasededados,
    i.id_trilha,
    i.sigla,
    i.servidor,
    i.hostname,
    i.instancia,
    i.sgbd,
    b.basededados,
        CASE
            WHEN ((t.tamanho IS NULL) OR (t.tamanho = (0)::double precision)) THEN (0)::real
            ELSE t.tamanho
        END AS tamanho,
    b.dbowner,
    b.descricao,
    b.created,
    b.dhcriacao,
    b.dhalteracao,
    b.ativo
   FROM (((sgbd.basededados b
     JOIN sgbd.vw_instancia i ON ((i.idinstancia = b.idinstancia)))
     LEFT JOIN ( SELECT bdtamanho.idbasededados,
            max(bdtamanho.datatimer) AS datatimer
           FROM sgbd.bdtamanho
          GROUP BY bdtamanho.idbasededados) bt ON ((bt.idbasededados = b.idbasededados)))
     LEFT JOIN sgbd.bdtamanho t ON (((t.idbasededados = bt.idbasededados) AND (t.datatimer = bt.datatimer))));


ALTER VIEW sgbd.vw_basededados OWNER TO "Sentinel";

--
-- Name: vw_dbtabela; Type: VIEW; Schema: sgbd; Owner: Sentinel
--

CREATE VIEW sgbd.vw_dbtabela AS
 SELECT b.idbasededados,
    tb.idbdtabela,
    b.basededados,
    tb.schema_name,
    tb.table_name,
    tb.dhcriacao,
    tb.dhalteracao
   FROM (sgbd.bdtabela tb
     JOIN sgbd.basededados b ON ((b.idbasededados = tb.idbasededados)));


ALTER VIEW sgbd.vw_dbtabela OWNER TO "Sentinel";

--
-- Name: vw_tbcoluna; Type: VIEW; Schema: sgbd; Owner: Sentinel
--

CREATE VIEW sgbd.vw_tbcoluna AS
 SELECT tb.idbasededados,
    tb.idbdtabela,
    cl.idtbcoluna,
    tb.basededados,
    tb.schema_name,
    tb.table_name,
    cl.colunn_name,
    cl.ordenal_positon,
    cl.data_type,
    cl.dhcriacao,
    cl.dhalteracao
   FROM (sgbd.tbcoluna cl
     JOIN sgbd.vw_dbtabela tb ON ((tb.idbdtabela = cl.idbdtabela)));


ALTER VIEW sgbd.vw_tbcoluna OWNER TO "Sentinel";

--
-- Name: vw_tbindex; Type: VIEW; Schema: sgbd; Owner: Sentinel
--

CREATE VIEW sgbd.vw_tbindex AS
 SELECT tb.idbasededados,
    tb.idbdtabela,
    ix.idtbindex,
    tb.basededados,
    tb.schema_name,
    tb.table_name,
    ix.index_name,
    ix.index_type,
    ix.dhcriacao,
    ix.dhalteracao
   FROM (sgbd.tbindex ix
     JOIN sgbd.vw_dbtabela tb ON ((tb.idbdtabela = ix.idbdtabela)));


ALTER VIEW sgbd.vw_tbindex OWNER TO "Sentinel";

--
-- Name: basededados; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.basededados (
    idinstancia integer NOT NULL,
    idtrilha integer,
    basededados character varying(150),
    dbowner character varying(100),
    descricao character varying(255),
    created timestamp without time zone
);


ALTER TABLE stage.basededados OWNER TO "Sentinel";

--
-- Name: bdtabela; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.bdtabela (
    idbasededados integer NOT NULL,
    schema_name character varying(128),
    table_name character varying(128)
);


ALTER TABLE stage.bdtabela OWNER TO "Sentinel";

--
-- Name: instancia_pg; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.instancia_pg (
    idinstancia integer NOT NULL,
    name text,
    setting text,
    unit text,
    category text
);


ALTER TABLE stage.instancia_pg OWNER TO "Sentinel";

--
-- Name: logins; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.logins (
    idinstancia integer NOT NULL,
    loginname character varying(128),
    tipo_login character varying(30)
);


ALTER TABLE stage.logins OWNER TO "Sentinel";

--
-- Name: logins_database; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.logins_database (
    idinstancia integer NOT NULL,
    loginname character varying(128),
    acessement jsonb,
    tipo_login character varying(30)
);


ALTER TABLE stage.logins_database OWNER TO "Sentinel";

--
-- Name: logins_instancia; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.logins_instancia (
    idinstancia integer NOT NULL,
    loginname character varying(128),
    acessement jsonb,
    tipo_login character varying(30)
);


ALTER TABLE stage.logins_instancia OWNER TO "Sentinel";

--
-- Name: tbcoluna; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.tbcoluna (
    idbasededados integer,
    table_catalog character varying(128),
    schema_name character varying(128),
    table_name character varying(128),
    colunn_name character varying(128),
    ordenal_positon integer,
    data_type character varying(128)
);


ALTER TABLE stage.tbcoluna OWNER TO "Sentinel";

--
-- Name: tbindex; Type: TABLE; Schema: stage; Owner: Sentinel
--

CREATE TABLE stage.tbindex (
    idbasededados integer NOT NULL,
    schemaname character varying(255),
    tablename character varying(255),
    index_name character varying(255),
    index_type character varying(255)
);


ALTER TABLE stage.tbindex OWNER TO "Sentinel";

--
-- Name: bdtamanho bdtamanho_pkey; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.bdtamanho
    ADD CONSTRAINT bdtamanho_pkey PRIMARY KEY (idbdtamanho);


--
-- Name: logins logins_pkey; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (idlogins);


--
-- Name: basededados pk_basededados_idbasededados; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.basededados
    ADD CONSTRAINT pk_basededados_idbasededados PRIMARY KEY (idbasededados);


--
-- Name: bdtabela pk_bdtabela_idbdtabela; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.bdtabela
    ADD CONSTRAINT pk_bdtabela_idbdtabela PRIMARY KEY (idbdtabela);


--
-- Name: clusterno pk_clusterno_idclusterno; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.clusterno
    ADD CONSTRAINT pk_clusterno_idclusterno PRIMARY KEY (idclusterno);


--
-- Name: clustertipo pk_clustertipo_idclustertipo; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.clustertipo
    ADD CONSTRAINT pk_clustertipo_idclustertipo PRIMARY KEY (idclustertipo);


--
-- Name: instancia pk_instancia_iddbinstancia; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.instancia
    ADD CONSTRAINT pk_instancia_iddbinstancia PRIMARY KEY (idinstancia);


--
-- Name: instancia_pg pk_instancia_pg_idinstancia_pg; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.instancia_pg
    ADD CONSTRAINT pk_instancia_pg_idinstancia_pg PRIMARY KEY (idinstancia_pg);


--
-- Name: logins_database pk_logins_database_idloginsdb; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins_database
    ADD CONSTRAINT pk_logins_database_idloginsdb PRIMARY KEY (idloginsdb);


--
-- Name: logins_instancia pk_logins_instancia_idloginsin; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins_instancia
    ADD CONSTRAINT pk_logins_instancia_idloginsin PRIMARY KEY (idloginsin);


--
-- Name: cluster pk_sdcluster_idcluster; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.cluster
    ADD CONSTRAINT pk_sdcluster_idcluster PRIMARY KEY (idcluster);


--
-- Name: tbcoluna tbcoluna_pkey; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.tbcoluna
    ADD CONSTRAINT tbcoluna_pkey PRIMARY KEY (idtbcoluna);


--
-- Name: tbindex tbindex_pkey; Type: CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.tbindex
    ADD CONSTRAINT tbindex_pkey PRIMARY KEY (idtbindex);


--
-- Name: bdtamanho fk_basededados_idbasededados; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.bdtamanho
    ADD CONSTRAINT fk_basededados_idbasededados FOREIGN KEY (idbasededados) REFERENCES sgbd.basededados(idbasededados);


--
-- Name: bdtabela fk_bdtabela_basededados; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.bdtabela
    ADD CONSTRAINT fk_bdtabela_basededados FOREIGN KEY (idbasededados) REFERENCES sgbd.basededados(idbasededados);


--
-- Name: cluster fk_cluster_idclustertipo; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.cluster
    ADD CONSTRAINT fk_cluster_idclustertipo FOREIGN KEY (idclustertipo) REFERENCES sgbd.clustertipo(idclustertipo);


--
-- Name: clusterno fk_clusterno_cluster; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.clusterno
    ADD CONSTRAINT fk_clusterno_cluster FOREIGN KEY (idcluster) REFERENCES sgbd.cluster(idcluster);


--
-- Name: instancia fk_instancia_cluster; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.instancia
    ADD CONSTRAINT fk_instancia_cluster FOREIGN KEY (idcluster) REFERENCES sgbd.cluster(idcluster);


--
-- Name: instancia_pg fk_instancia_pg_instancia; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.instancia_pg
    ADD CONSTRAINT fk_instancia_pg_instancia FOREIGN KEY (idinstancia) REFERENCES sgbd.instancia(idinstancia);


--
-- Name: logins_database fk_logins_database_instancia; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins_database
    ADD CONSTRAINT fk_logins_database_instancia FOREIGN KEY (idlogins) REFERENCES sgbd.logins(idlogins);


--
-- Name: logins_instancia fk_logins_instancia; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins_instancia
    ADD CONSTRAINT fk_logins_instancia FOREIGN KEY (idlogins) REFERENCES sgbd.logins(idlogins);


--
-- Name: basededados fk_servidor_basededados; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.basededados
    ADD CONSTRAINT fk_servidor_basededados FOREIGN KEY (idinstancia) REFERENCES sgbd.instancia(idinstancia);


--
-- Name: logins fk_servidor_basededados; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.logins
    ADD CONSTRAINT fk_servidor_basededados FOREIGN KEY (idinstancia) REFERENCES sgbd.instancia(idinstancia);


--
-- Name: tbcoluna fk_tbcoluna_bdtabela; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.tbcoluna
    ADD CONSTRAINT fk_tbcoluna_bdtabela FOREIGN KEY (idbdtabela) REFERENCES sgbd.bdtabela(idbdtabela);


--
-- Name: tbindex fk_tbindex_bdtabela; Type: FK CONSTRAINT; Schema: sgbd; Owner: Sentinel
--

ALTER TABLE ONLY sgbd.tbindex
    ADD CONSTRAINT fk_tbindex_bdtabela FOREIGN KEY (idbdtabela) REFERENCES sgbd.bdtabela(idbdtabela);


--
-- PostgreSQL database dump complete
--

