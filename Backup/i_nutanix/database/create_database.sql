CREATE DATABASE sds_int_nutanix
    WITH
    OWNER = "Sentinel"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE SCHEMA IF NOT EXISTS stage
    AUTHORIZATION "Sentinel";

CREATE TABLE IF NOT EXISTS stage.vm
(
    pchostname character varying(100) COLLATE pg_catalog."default",
    powerstate character varying(10) COLLATE pg_catalog."default",
    vmname character varying(256) COLLATE pg_catalog."default",
    ipaddresses character varying(100) COLLATE pg_catalog."default",
    hypervisortype character varying(100) COLLATE pg_catalog."default",
    hostname character varying(256) COLLATE pg_catalog."default",
    memorycapacityinbytes text COLLATE pg_catalog."default",
    memoryreservedcapacityinbytes text COLLATE pg_catalog."default",
    numvcpus text COLLATE pg_catalog."default",
    numnetworkadapters text COLLATE pg_catalog."default",
    controllervm character varying(10) COLLATE pg_catalog."default",
    vdisknames text COLLATE pg_catalog."default",
    vdiskfilepaths text COLLATE pg_catalog."default",
    diskcapacityinbytes text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS stage.vm
    OWNER to "Sentinel";        