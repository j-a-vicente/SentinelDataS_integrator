CREATE TABLE ad_computer (
    SID varchar(100),
    Name text,
    DisplayName text,
    SamAccountName text,
    Description text,
    ObjectClass varchar(30),
    PrimaryGroup text,
    MemberOf text,
    OperatingSystem text,
    OperatingSystemHotfix text,
    OperatingSystemServicePack text,
    OperatingSystemVersion text,
    CanonicalName text,
    Enabled boolean,
    IPv4Address text,
    Created timestamp,
    Deleted timestamp,
    Modified timestamp,
    LastLogonDate timestamp,
    logonCount int,
    PasswordExpired boolean,
    PasswordLastSet timestamp,
    AuthenticationPolicy text,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

CREATE TABLE ad_contact (
    Name varchar(100),
    DisplayName varchar(100),
    mailNickname varchar(100),
    mail varchar(100),
    CanonicalName text,
    DistinguishedName text,
    created timestamp,
    Deleted timestamp,
    Modified timestamp,
    LastUpdateEtl timestamp DEFAULT current_timestamp
);

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
