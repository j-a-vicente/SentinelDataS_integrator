USE [master]
GO

CREATE DATABASE [dcdados]
 CONTAINMENT = NONE
 -- Disco de dados 01
 ON  PRIMARY 
( NAME = N'dcdados00', FILENAME = N'E:\MSSQL\Data\dcdados_00.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 -- Disco de dados 02
 FILEGROUP [SECOND] 
( NAME = N'dcdados01', FILENAME = N'E:\MSSQL\Data\dcdados_01.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 -- Disco de auditoria
 FILEGROUP [AUDITING] 
( NAME = N'dcdados_auditing', FILENAME = N'E:\MSSQL\Data\dcdados_auditing.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 -- Disco de Index
FILEGROUP [INDEX] 
( NAME = N'dcdados_index', FILENAME = N'E:\MSSQL\Data\dcdados_index.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
  -- Disco Fato 01
 FILEGROUP [Fato01] 
( NAME = N'dcdados_fato01', FILENAME = N'E:\MSSQL\Data\dcdados_fato01.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
  -- Disco Fato 02
 FILEGROUP [Fato02] 
( NAME = N'dcdados_fato02', FILENAME = N'E:\MSSQL\Data\dcdados_fato02.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
  -- Disco Fato 03
 FILEGROUP [Fato03] 
( NAME = N'dcdados_fato03', FILENAME = N'E:\MSSQL\Data\dcdados_fato03.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
  -- Disco de archives
 FILEGROUP [ARCHIVES] 
( NAME = N'dcdados_archives', FILENAME = N'E:\MSSQL\Data\archives.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
  -- Disco de log transacional
 LOG ON 
( NAME = N'dcdados_log', FILENAME = N'E:\MSSQL\Data\dcdados_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dcdados].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
