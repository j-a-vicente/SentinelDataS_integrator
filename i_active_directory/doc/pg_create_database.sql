CREATE TABLE IF NOT EXISTS stage.ad_contact
(
    sid character varying(100) COLLATE pg_catalog."default",
    name text COLLATE pg_catalog."default",
    dnshostname text COLLATE pg_catalog."default",
    samaccountname text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    objectcategory text COLLATE pg_catalog."default",
    objectclass text COLLATE pg_catalog."default",
    operatingsystem text COLLATE pg_catalog."default",
    operatingsystemversion text COLLATE pg_catalog."default",
    distinguishedname text COLLATE pg_catalog."default",
    whencreated timestamp without time zone,
    whenchanged timestamp without time zone,
    lastlogontimestamp timestamp without time zone,
    lastupdateetl timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cont bigint
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS stage.ad_computer
    OWNER to "EtlMonitorPowerBI";

CREATE TABLE stage.ad_contact (
    Name varchar(100),
    DisplayName varchar(100),
    mailNickname varchar(100),
    mail varchar(100),
    memberOf text,
    distinguishedName text,
    objectCategory text,
    objectClass text,
    whenCreated timestamp,
    whenChanged timestamp,
    lastupdateetl timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cont bigint
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS stage.ad_contact
    OWNER to "EtlMonitorPowerBI";

CREATE TABLE ad_domain_controller (
    Name text,
    HostName text,
    IPv4Address text,
    OperatingSystem text,
    OperatingSystemVersion text,
    Site text,
    Enabled boolean,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_gpo (
    ID varchar(100),
    DisplayName text,
    DomainName varchar(100),
    Owner varchar(100),
    GpoStatus varchar(100),
    Description text,
    UserVersion varchar(100),
    ComputerVersion varchar(100),
    CreationTime timestamp,
    ModificationTime timestamp,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_group (
    SID text,
    Name text,
    DisplayName text,
    SamAccountName text,
    Description text,
    CanonicalName text,
    DistinguishedName text,
    GroupCategory text,
    Member text,
    MemberOf text,
    GroupScope varchar(30),
    ObjectClass varchar(30),
    ProtectedFromAccidentalDeletion boolean,
    Created timestamp,
    Deleted timestamp,
    Modified timestamp,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_group_member (
    Grupo text,
    Tipo varchar(10),
    SID text,
    Member text,
    SamAccountName text,
	LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_ou (
    ObjectGUID varchar(100),
    Name varchar(100),
    ObjectClass varchar(30),
    DistinguishedName text,
    ManagedBy text,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_ou_member (
    OU text,
    DistinguishedName text,
    Tipo varchar(20),
    SID text,
    Member text,
    SamAccountName text,
	LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_user (
    SID varchar(100),
    Name varchar(100),
    DisplayName varchar(100),
    SamAccountName varchar(100),
    mail varchar(100),
    Title text,
    Department varchar(100),
    Description text,
    employeeType varchar(30),
    Company text,
    Office text,
    City text,
    DistinguishedName text,
    MemberOf text,
    createTimeStamp timestamp,
    Deleted timestamp,
    Modified timestamp,
    PasswordLastSet timestamp,
    AccountExpirationDate timestamp,
    msExchWhenMailboxCreated timestamp,
    LastLogonDate timestamp,
    EmailAddress varchar(200),
    MobilePhone varchar(100),
    msExchRemoteRecipientType int,
    ObjectClass varchar(30),
    PasswordExpired boolean,
    PasswordNeverExpires boolean,
    PasswordNotRequired boolean,
    Enabled boolean,
    LockedOut boolean,
    CannotChangePassword boolean,
    userAccountControl int,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_user_account_control (
    PropertyFlag varchar(255),
    ValueInHexadecimal varchar(255),
    ValueInDecimal float,
    StatusAccount text,
    Statusdescription varchar(255),
	LastUpdateEtl timestamp DEFAULT current_timestamp
);
