PGDMP      5                }            sds_database    16.3 (Debian 16.3-1.pgdg120+1)    17.1 ]    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    5970185    sds_database    DATABASE     w   CREATE DATABASE sds_database WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE sds_database;
                     Sentinel    false            �            1259    5970238    basededados_idbasededados_seq    SEQUENCE     �   CREATE SEQUENCE public.basededados_idbasededados_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.basededados_idbasededados_seq;
       public               Sentinel    false            �            1259    5970239    basededados    TABLE     	  CREATE TABLE public.basededados (
    idbasededados integer DEFAULT nextval('public.basededados_idbasededados_seq'::regclass) NOT NULL,
    idinstancia integer NOT NULL,
    idtrilha integer,
    basededados character varying(150),
    dbowner character varying(100),
    config_database text,
    descricao character varying(255),
    created timestamp without time zone,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);
    DROP TABLE public.basededados;
       public         heap r       Sentinel    false    223            �            1259    5970254    bdtabela_idbdtabela_seq    SEQUENCE     �   CREATE SEQUENCE public.bdtabela_idbdtabela_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.bdtabela_idbdtabela_seq;
       public               Sentinel    false            �            1259    5970255    bdtabela    TABLE     c  CREATE TABLE public.bdtabela (
    idbdtabela integer DEFAULT nextval('public.bdtabela_idbdtabela_seq'::regclass) NOT NULL,
    idbasededados integer NOT NULL,
    schema_name character varying(128),
    table_name character varying(128),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.bdtabela;
       public         heap r       Sentinel    false    225            �            1259    5970267    bdtamanho_idbdtamanho_seq    SEQUENCE     �   CREATE SEQUENCE public.bdtamanho_idbdtamanho_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.bdtamanho_idbdtamanho_seq;
       public               Sentinel    false            �            1259    5970268 	   bdtamanho    TABLE     �   CREATE TABLE public.bdtamanho (
    idbdtamanho integer DEFAULT nextval('public.bdtamanho_idbdtamanho_seq'::regclass) NOT NULL,
    idbasededados integer NOT NULL,
    tamanho real,
    datatimer timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.bdtamanho;
       public         heap r       Sentinel    false    227            �            1259    5970193    cluster_idcluster_seq    SEQUENCE     ~   CREATE SEQUENCE public.cluster_idcluster_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cluster_idcluster_seq;
       public               Sentinel    false            �            1259    5970194    cluster    TABLE     l  CREATE TABLE public.cluster (
    idcluster integer DEFAULT nextval('public.cluster_idcluster_seq'::regclass) NOT NULL,
    idclustertipo integer,
    clustername character varying(60),
    ip character varying(50),
    ativo boolean DEFAULT true,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.cluster;
       public         heap r       Sentinel    false    217            �            1259    5970207    clusterno_idclusterno_seq    SEQUENCE     �   CREATE SEQUENCE public.clusterno_idclusterno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.clusterno_idclusterno_seq;
       public               Sentinel    false            �            1259    5970208 	   clusterno    TABLE     �   CREATE TABLE public.clusterno (
    idclusterno integer DEFAULT nextval('public.clusterno_idclusterno_seq'::regclass) NOT NULL,
    id_serverhost integer NOT NULL,
    idcluster integer NOT NULL,
    ativo boolean DEFAULT true
);
    DROP TABLE public.clusterno;
       public         heap r       Sentinel    false    219            �            1259    5970186    clustertipo_idclustertipo_seq    SEQUENCE     �   CREATE SEQUENCE public.clustertipo_idclustertipo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.clustertipo_idclustertipo_seq;
       public               Sentinel    false            �            1259    5970187    clustertipo    TABLE     �   CREATE TABLE public.clustertipo (
    idclustertipo integer DEFAULT nextval('public.clustertipo_idclustertipo_seq'::regclass) NOT NULL,
    tipo character varying(50)
);
    DROP TABLE public.clustertipo;
       public         heap r       Sentinel    false    215            �            1259    5970220    instancia_idinstancia_seq    SEQUENCE     �   CREATE SEQUENCE public.instancia_idinstancia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.instancia_idinstancia_seq;
       public               Sentinel    false            �            1259    5970221 	   instancia    TABLE     �  CREATE TABLE public.instancia (
    idinstancia integer DEFAULT nextval('public.instancia_idinstancia_seq'::regclass) NOT NULL,
    id_serverhost integer NOT NULL,
    idcluster integer,
    id_trilha integer NOT NULL,
    id_impacto integer,
    id_probabilidade integer,
    id_servico integer,
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
    config_sgbd text,
    startinstancia timestamp without time zone,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true,
    status_bd character varying(50)
);
    DROP TABLE public.instancia;
       public         heap r       Sentinel    false    221            �            1259    5970338    logins_idlogins_seq    SEQUENCE     |   CREATE SEQUENCE public.logins_idlogins_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.logins_idlogins_seq;
       public               Sentinel    false            �            1259    5970339    logins    TABLE     v  CREATE TABLE public.logins (
    idlogins integer DEFAULT nextval('public.logins_idlogins_seq'::regclass) NOT NULL,
    idinstancia integer NOT NULL,
    loginname character varying(128),
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);
    DROP TABLE public.logins;
       public         heap r       Sentinel    false    237            �            1259    5970352    logins_database_idloginsdb_seq    SEQUENCE     �   CREATE SEQUENCE public.logins_database_idloginsdb_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.logins_database_idloginsdb_seq;
       public               Sentinel    false            �            1259    5970354    logins_database    TABLE     y  CREATE TABLE public.logins_database (
    idloginsdb integer DEFAULT nextval('public.logins_database_idloginsdb_seq'::regclass) NOT NULL,
    idlogins integer NOT NULL,
    acessement jsonb,
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);
 #   DROP TABLE public.logins_database;
       public         heap r       Sentinel    false    239            �            1259    5970353    logins_instancia_idloginsin_seq    SEQUENCE     �   CREATE SEQUENCE public.logins_instancia_idloginsin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.logins_instancia_idloginsin_seq;
       public               Sentinel    false            �            1259    5970369    logins_instancia    TABLE     {  CREATE TABLE public.logins_instancia (
    idloginsin integer DEFAULT nextval('public.logins_instancia_idloginsin_seq'::regclass) NOT NULL,
    idlogins integer NOT NULL,
    acessement jsonb,
    tipo_login character varying(30),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone,
    ativo boolean DEFAULT true
);
 $   DROP TABLE public.logins_instancia;
       public         heap r       Sentinel    false    240            �            1259    5970280    tbcoluna_idtbcoluna_seq    SEQUENCE     �   CREATE SEQUENCE public.tbcoluna_idtbcoluna_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tbcoluna_idtbcoluna_seq;
       public               Sentinel    false            �            1259    5970281    tbcoluna    TABLE     |  CREATE TABLE public.tbcoluna (
    idtbcoluna integer DEFAULT nextval('public.tbcoluna_idtbcoluna_seq'::regclass) NOT NULL,
    idbdtabela integer NOT NULL,
    colunn_name character varying(128),
    ordenal_positon integer,
    data_type character varying(128),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.tbcoluna;
       public         heap r       Sentinel    false    229            �            1259    5970293    tbindex_idtbindex_seq    SEQUENCE     ~   CREATE SEQUENCE public.tbindex_idtbindex_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tbindex_idtbindex_seq;
       public               Sentinel    false            �            1259    5970294    tbindex    TABLE     [  CREATE TABLE public.tbindex (
    idtbindex integer DEFAULT nextval('public.tbindex_idtbindex_seq'::regclass) NOT NULL,
    idbdtabela integer NOT NULL,
    index_name character varying(255),
    index_type character varying(255),
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.tbindex;
       public         heap r       Sentinel    false    231            �            1259    5970323    tbindex_idtbindexstatic_seq    SEQUENCE     �   CREATE SEQUENCE public.tbindex_idtbindexstatic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.tbindex_idtbindexstatic_seq;
       public               Sentinel    false            �            1259    5970308    tbindexfrag_idtbindexfrag_seq    SEQUENCE     �   CREATE SEQUENCE public.tbindexfrag_idtbindexfrag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tbindexfrag_idtbindexfrag_seq;
       public               Sentinel    false            �            1259    5970309    tbindexfrag    TABLE     3  CREATE TABLE public.tbindexfrag (
    idtbindexfrag integer DEFAULT nextval('public.tbindexfrag_idtbindexfrag_seq'::regclass) NOT NULL,
    idtbindex integer NOT NULL,
    fragmentacao text,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.tbindexfrag;
       public         heap r       Sentinel    false    233            �            1259    5970324    tbindexstatic    TABLE     2  CREATE TABLE public.tbindexstatic (
    idtbindexstatic integer DEFAULT nextval('public.tbindex_idtbindexstatic_seq'::regclass) NOT NULL,
    idtbindex integer NOT NULL,
    ix_static text,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
 !   DROP TABLE public.tbindexstatic;
       public         heap r       Sentinel    false    235            �            1259    5970384    tbstatic_idtbstatic_seq    SEQUENCE     �   CREATE SEQUENCE public.tbstatic_idtbstatic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tbstatic_idtbstatic_seq;
       public               Sentinel    false            �            1259    5970385    tbstatic    TABLE     6  CREATE TABLE public.tbstatic (
    idtbstatic integer DEFAULT nextval('public.tbstatic_idtbstatic_seq'::regclass) NOT NULL,
    idbdtabela integer NOT NULL,
    totalmb real,
    tbstatic text,
    dhcriacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dhalteracao timestamp without time zone
);
    DROP TABLE public.tbstatic;
       public         heap r       Sentinel    false    243            �          0    5970239    basededados 
   TABLE DATA           �   COPY public.basededados (idbasededados, idinstancia, idtrilha, basededados, dbowner, config_database, descricao, created, dhcriacao, dhalteracao, ativo) FROM stdin;
    public               Sentinel    false    224   s�       �          0    5970255    bdtabela 
   TABLE DATA           n   COPY public.bdtabela (idbdtabela, idbasededados, schema_name, table_name, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    226   ��       �          0    5970268 	   bdtamanho 
   TABLE DATA           S   COPY public.bdtamanho (idbdtamanho, idbasededados, tamanho, datatimer) FROM stdin;
    public               Sentinel    false    228   ��       �          0    5970194    cluster 
   TABLE DATA           k   COPY public.cluster (idcluster, idclustertipo, clustername, ip, ativo, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    218   ʀ       �          0    5970208 	   clusterno 
   TABLE DATA           Q   COPY public.clusterno (idclusterno, id_serverhost, idcluster, ativo) FROM stdin;
    public               Sentinel    false    220   _�       �          0    5970187    clustertipo 
   TABLE DATA           :   COPY public.clustertipo (idclustertipo, tipo) FROM stdin;
    public               Sentinel    false    216   ��       �          0    5970221 	   instancia 
   TABLE DATA           `  COPY public.instancia (idinstancia, id_serverhost, idcluster, id_trilha, id_impacto, id_probabilidade, id_servico, instancia, sgbd, ip, conectstring, porta, cluster, versao, productversion, descricao, funcaoserver, sobreadministracao, memoryconfig, cpu, estanciaativo, config_sgbd, startinstancia, dhcriacao, dhalteracao, ativo, status_bd) FROM stdin;
    public               Sentinel    false    222   �       �          0    5970339    logins 
   TABLE DATA           m   COPY public.logins (idlogins, idinstancia, loginname, tipo_login, dhcriacao, dhalteracao, ativo) FROM stdin;
    public               Sentinel    false    238   J�       �          0    5970354    logins_database 
   TABLE DATA           v   COPY public.logins_database (idloginsdb, idlogins, acessement, tipo_login, dhcriacao, dhalteracao, ativo) FROM stdin;
    public               Sentinel    false    241   g�       �          0    5970369    logins_instancia 
   TABLE DATA           w   COPY public.logins_instancia (idloginsin, idlogins, acessement, tipo_login, dhcriacao, dhalteracao, ativo) FROM stdin;
    public               Sentinel    false    242   ��       �          0    5970281    tbcoluna 
   TABLE DATA           {   COPY public.tbcoluna (idtbcoluna, idbdtabela, colunn_name, ordenal_positon, data_type, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    230   ��       �          0    5970294    tbindex 
   TABLE DATA           h   COPY public.tbindex (idtbindex, idbdtabela, index_name, index_type, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    232   ��       �          0    5970309    tbindexfrag 
   TABLE DATA           e   COPY public.tbindexfrag (idtbindexfrag, idtbindex, fragmentacao, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    234   ۃ       �          0    5970324    tbindexstatic 
   TABLE DATA           f   COPY public.tbindexstatic (idtbindexstatic, idtbindex, ix_static, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    236   ��       �          0    5970385    tbstatic 
   TABLE DATA           e   COPY public.tbstatic (idtbstatic, idbdtabela, totalmb, tbstatic, dhcriacao, dhalteracao) FROM stdin;
    public               Sentinel    false    244   �       �           0    0    basededados_idbasededados_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.basededados_idbasededados_seq', 1, false);
          public               Sentinel    false    223            �           0    0    bdtabela_idbdtabela_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.bdtabela_idbdtabela_seq', 1, false);
          public               Sentinel    false    225            �           0    0    bdtamanho_idbdtamanho_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.bdtamanho_idbdtamanho_seq', 1, false);
          public               Sentinel    false    227            �           0    0    cluster_idcluster_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.cluster_idcluster_seq', 3, true);
          public               Sentinel    false    217            �           0    0    clusterno_idclusterno_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.clusterno_idclusterno_seq', 6, true);
          public               Sentinel    false    219            �           0    0    clustertipo_idclustertipo_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.clustertipo_idclustertipo_seq', 2, true);
          public               Sentinel    false    215            �           0    0    instancia_idinstancia_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.instancia_idinstancia_seq', 10, true);
          public               Sentinel    false    221            �           0    0    logins_database_idloginsdb_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.logins_database_idloginsdb_seq', 1, false);
          public               Sentinel    false    239            �           0    0    logins_idlogins_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.logins_idlogins_seq', 1, false);
          public               Sentinel    false    237            �           0    0    logins_instancia_idloginsin_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.logins_instancia_idloginsin_seq', 1, false);
          public               Sentinel    false    240            �           0    0    tbcoluna_idtbcoluna_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.tbcoluna_idtbcoluna_seq', 1, false);
          public               Sentinel    false    229            �           0    0    tbindex_idtbindex_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.tbindex_idtbindex_seq', 1, false);
          public               Sentinel    false    231            �           0    0    tbindex_idtbindexstatic_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tbindex_idtbindexstatic_seq', 1, false);
          public               Sentinel    false    235            �           0    0    tbindexfrag_idtbindexfrag_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.tbindexfrag_idtbindexfrag_seq', 1, false);
          public               Sentinel    false    233            �           0    0    tbstatic_idtbstatic_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.tbstatic_idtbstatic_seq', 1, false);
          public               Sentinel    false    243            �           2606    5970274    bdtamanho bdtamanho_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.bdtamanho
    ADD CONSTRAINT bdtamanho_pkey PRIMARY KEY (idbdtamanho);
 B   ALTER TABLE ONLY public.bdtamanho DROP CONSTRAINT bdtamanho_pkey;
       public                 Sentinel    false    228                       2606    5970346    logins logins_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (idlogins);
 <   ALTER TABLE ONLY public.logins DROP CONSTRAINT logins_pkey;
       public                 Sentinel    false    238            �           2606    5970248 (   basededados pk_basededados_idbasededados 
   CONSTRAINT     q   ALTER TABLE ONLY public.basededados
    ADD CONSTRAINT pk_basededados_idbasededados PRIMARY KEY (idbasededados);
 R   ALTER TABLE ONLY public.basededados DROP CONSTRAINT pk_basededados_idbasededados;
       public                 Sentinel    false    224            �           2606    5970261    bdtabela pk_bdtabela_idbdtabela 
   CONSTRAINT     e   ALTER TABLE ONLY public.bdtabela
    ADD CONSTRAINT pk_bdtabela_idbdtabela PRIMARY KEY (idbdtabela);
 I   ALTER TABLE ONLY public.bdtabela DROP CONSTRAINT pk_bdtabela_idbdtabela;
       public                 Sentinel    false    226            �           2606    5970214 "   clusterno pk_clusterno_idclusterno 
   CONSTRAINT     i   ALTER TABLE ONLY public.clusterno
    ADD CONSTRAINT pk_clusterno_idclusterno PRIMARY KEY (idclusterno);
 L   ALTER TABLE ONLY public.clusterno DROP CONSTRAINT pk_clusterno_idclusterno;
       public                 Sentinel    false    220            �           2606    5970192 (   clustertipo pk_clustertipo_idclustertipo 
   CONSTRAINT     q   ALTER TABLE ONLY public.clustertipo
    ADD CONSTRAINT pk_clustertipo_idclustertipo PRIMARY KEY (idclustertipo);
 R   ALTER TABLE ONLY public.clustertipo DROP CONSTRAINT pk_clustertipo_idclustertipo;
       public                 Sentinel    false    216            �           2606    5970232 $   instancia pk_instancia_iddbinstancia 
   CONSTRAINT     k   ALTER TABLE ONLY public.instancia
    ADD CONSTRAINT pk_instancia_iddbinstancia PRIMARY KEY (idinstancia);
 N   ALTER TABLE ONLY public.instancia DROP CONSTRAINT pk_instancia_iddbinstancia;
       public                 Sentinel    false    222                       2606    5970363 -   logins_database pk_logins_database_idloginsdb 
   CONSTRAINT     s   ALTER TABLE ONLY public.logins_database
    ADD CONSTRAINT pk_logins_database_idloginsdb PRIMARY KEY (idloginsdb);
 W   ALTER TABLE ONLY public.logins_database DROP CONSTRAINT pk_logins_database_idloginsdb;
       public                 Sentinel    false    241            	           2606    5970378 /   logins_instancia pk_logins_instancia_idloginsin 
   CONSTRAINT     u   ALTER TABLE ONLY public.logins_instancia
    ADD CONSTRAINT pk_logins_instancia_idloginsin PRIMARY KEY (idloginsin);
 Y   ALTER TABLE ONLY public.logins_instancia DROP CONSTRAINT pk_logins_instancia_idloginsin;
       public                 Sentinel    false    242            �           2606    5970201    cluster pk_sdcluster_idcluster 
   CONSTRAINT     c   ALTER TABLE ONLY public.cluster
    ADD CONSTRAINT pk_sdcluster_idcluster PRIMARY KEY (idcluster);
 H   ALTER TABLE ONLY public.cluster DROP CONSTRAINT pk_sdcluster_idcluster;
       public                 Sentinel    false    218            �           2606    5970287    tbcoluna tbcoluna_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbcoluna
    ADD CONSTRAINT tbcoluna_pkey PRIMARY KEY (idtbcoluna);
 @   ALTER TABLE ONLY public.tbcoluna DROP CONSTRAINT tbcoluna_pkey;
       public                 Sentinel    false    230            �           2606    5970302    tbindex tbindex_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.tbindex
    ADD CONSTRAINT tbindex_pkey PRIMARY KEY (idtbindex);
 >   ALTER TABLE ONLY public.tbindex DROP CONSTRAINT tbindex_pkey;
       public                 Sentinel    false    232                       2606    5970317    tbindexfrag tbindexfrag_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.tbindexfrag
    ADD CONSTRAINT tbindexfrag_pkey PRIMARY KEY (idtbindexfrag);
 F   ALTER TABLE ONLY public.tbindexfrag DROP CONSTRAINT tbindexfrag_pkey;
       public                 Sentinel    false    234                       2606    5970332     tbindexstatic tbindexstatic_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.tbindexstatic
    ADD CONSTRAINT tbindexstatic_pkey PRIMARY KEY (idtbindexstatic);
 J   ALTER TABLE ONLY public.tbindexstatic DROP CONSTRAINT tbindexstatic_pkey;
       public                 Sentinel    false    236                       2606    5970393    tbstatic tbtbstatic_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tbstatic
    ADD CONSTRAINT tbtbstatic_pkey PRIMARY KEY (idtbstatic);
 B   ALTER TABLE ONLY public.tbstatic DROP CONSTRAINT tbtbstatic_pkey;
       public                 Sentinel    false    244                       2606    5970275 &   bdtamanho fk_basededados_idbasededados    FK CONSTRAINT     �   ALTER TABLE ONLY public.bdtamanho
    ADD CONSTRAINT fk_basededados_idbasededados FOREIGN KEY (idbasededados) REFERENCES public.basededados(idbasededados);
 P   ALTER TABLE ONLY public.bdtamanho DROP CONSTRAINT fk_basededados_idbasededados;
       public               Sentinel    false    3319    224    228                       2606    5970262     bdtabela fk_bdtabela_basededados    FK CONSTRAINT     �   ALTER TABLE ONLY public.bdtabela
    ADD CONSTRAINT fk_bdtabela_basededados FOREIGN KEY (idbasededados) REFERENCES public.basededados(idbasededados);
 J   ALTER TABLE ONLY public.bdtabela DROP CONSTRAINT fk_bdtabela_basededados;
       public               Sentinel    false    226    3319    224                       2606    5970202     cluster fk_cluster_idclustertipo    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster
    ADD CONSTRAINT fk_cluster_idclustertipo FOREIGN KEY (idclustertipo) REFERENCES public.clustertipo(idclustertipo);
 J   ALTER TABLE ONLY public.cluster DROP CONSTRAINT fk_cluster_idclustertipo;
       public               Sentinel    false    216    3311    218                       2606    5970215    clusterno fk_clusterno_cluster    FK CONSTRAINT     �   ALTER TABLE ONLY public.clusterno
    ADD CONSTRAINT fk_clusterno_cluster FOREIGN KEY (idcluster) REFERENCES public.cluster(idcluster);
 H   ALTER TABLE ONLY public.clusterno DROP CONSTRAINT fk_clusterno_cluster;
       public               Sentinel    false    220    3313    218                       2606    5970233    instancia fk_instancia_cluster    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia
    ADD CONSTRAINT fk_instancia_cluster FOREIGN KEY (idcluster) REFERENCES public.cluster(idcluster);
 H   ALTER TABLE ONLY public.instancia DROP CONSTRAINT fk_instancia_cluster;
       public               Sentinel    false    218    3313    222                       2606    5970364 ,   logins_database fk_logins_database_instancia    FK CONSTRAINT     �   ALTER TABLE ONLY public.logins_database
    ADD CONSTRAINT fk_logins_database_instancia FOREIGN KEY (idlogins) REFERENCES public.logins(idlogins);
 V   ALTER TABLE ONLY public.logins_database DROP CONSTRAINT fk_logins_database_instancia;
       public               Sentinel    false    241    238    3333                       2606    5970379 $   logins_instancia fk_logins_instancia    FK CONSTRAINT     �   ALTER TABLE ONLY public.logins_instancia
    ADD CONSTRAINT fk_logins_instancia FOREIGN KEY (idlogins) REFERENCES public.logins(idlogins);
 N   ALTER TABLE ONLY public.logins_instancia DROP CONSTRAINT fk_logins_instancia;
       public               Sentinel    false    242    3333    238                       2606    5970249 #   basededados fk_servidor_basededados    FK CONSTRAINT     �   ALTER TABLE ONLY public.basededados
    ADD CONSTRAINT fk_servidor_basededados FOREIGN KEY (idinstancia) REFERENCES public.instancia(idinstancia);
 M   ALTER TABLE ONLY public.basededados DROP CONSTRAINT fk_servidor_basededados;
       public               Sentinel    false    224    222    3317                       2606    5970347    logins fk_servidor_basededados    FK CONSTRAINT     �   ALTER TABLE ONLY public.logins
    ADD CONSTRAINT fk_servidor_basededados FOREIGN KEY (idinstancia) REFERENCES public.instancia(idinstancia);
 H   ALTER TABLE ONLY public.logins DROP CONSTRAINT fk_servidor_basededados;
       public               Sentinel    false    3317    222    238                       2606    5970288    tbcoluna fk_tbcoluna_bdtabela    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbcoluna
    ADD CONSTRAINT fk_tbcoluna_bdtabela FOREIGN KEY (idbdtabela) REFERENCES public.bdtabela(idbdtabela);
 G   ALTER TABLE ONLY public.tbcoluna DROP CONSTRAINT fk_tbcoluna_bdtabela;
       public               Sentinel    false    226    230    3321                       2606    5970303    tbindex fk_tbindex_bdtabela    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbindex
    ADD CONSTRAINT fk_tbindex_bdtabela FOREIGN KEY (idbdtabela) REFERENCES public.bdtabela(idbdtabela);
 E   ALTER TABLE ONLY public.tbindex DROP CONSTRAINT fk_tbindex_bdtabela;
       public               Sentinel    false    3321    226    232                       2606    5970333     tbindexstatic fk_tbindex_tbindex    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbindexstatic
    ADD CONSTRAINT fk_tbindex_tbindex FOREIGN KEY (idtbindex) REFERENCES public.tbindex(idtbindex);
 J   ALTER TABLE ONLY public.tbindexstatic DROP CONSTRAINT fk_tbindex_tbindex;
       public               Sentinel    false    232    236    3327                       2606    5970318 "   tbindexfrag fk_tbindexfrag_tbindex    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbindexfrag
    ADD CONSTRAINT fk_tbindexfrag_tbindex FOREIGN KEY (idtbindex) REFERENCES public.tbindex(idtbindex);
 L   ALTER TABLE ONLY public.tbindexfrag DROP CONSTRAINT fk_tbindexfrag_tbindex;
       public               Sentinel    false    234    3327    232                       2606    5970394    tbstatic fk_tbstatic_bdtabela    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbstatic
    ADD CONSTRAINT fk_tbstatic_bdtabela FOREIGN KEY (idbdtabela) REFERENCES public.bdtabela(idbdtabela);
 G   ALTER TABLE ONLY public.tbstatic DROP CONSTRAINT fk_tbstatic_bdtabela;
       public               Sentinel    false    244    3321    226            �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�uλ
�@F�z�)|�����5�E/[�1 ������"�9����C;����/_oO���)� �N�S�`US��%#"Ѹs�Ώڴa���9�kJ
������m�
2���`\4k�5�s���39      �   6   x�%ƹ  �x]���B�/,�h�r뭢%��|i(�����bfM
!      �   5   x�3�t�)-.I-R�QN-*2�3s�.#l��9剕�
�y\1z\\\ ��
      �   P  x���Kj�0�|�\ bf��k�B!���ަ!��8�r+Cldd� �ǌ$T�V�'��A�g�u�����|�`TI�4Β,�馿���& ��	wȉ)Y��:�WU��ǧ�3�F�� lۏS=���Ԉ����u��/c��w��@���?�2"-M��]J�4��R��h�D��"��i� ���e�͈v��y�Hdf��SD����8ي�T��`���B���}pqRD_R&,����y�&��ϳ�UFpVF���C3)�#-�fi5�&"M q�a,).gy�(&mFP�N�\�ŋY:�`�^��� �ѲӜ�ꪪ~��Q      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     