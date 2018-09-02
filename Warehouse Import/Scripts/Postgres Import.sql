--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 10.1

-- Started on 2018-05-10 18:32:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 16 (class 2615 OID 349904)
-- Name: pf_datawarehouse; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pf_datawarehouse;


ALTER SCHEMA pf_datawarehouse OWNER TO postgres;

SET search_path = pf_datawarehouse, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 775 (class 1259 OID 358009)
-- Name: area_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE area_dim (
    id integer,
    city character varying,
    country character varying
);


ALTER TABLE area_dim OWNER TO postgres;

--
-- TOC entry 776 (class 1259 OID 358016)
-- Name: artist_credit_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE artist_credit_dim (
    id integer,
    name character varying,
    id_artist integer,
    artist_count smallint
);


ALTER TABLE artist_credit_dim OWNER TO postgres;

--
-- TOC entry 777 (class 1259 OID 358030)
-- Name: artist_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE artist_dim (
    id integer,
    name character varying,
    type character varying(255),
    area integer,
    gender character varying(255)
);


ALTER TABLE artist_dim OWNER TO postgres;

--
-- TOC entry 778 (class 1259 OID 358037)
-- Name: date_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE date_dim (
    id integer,
    date date,
    day integer,
    month integer,
    year integer,
    dayoftheweek character varying(15),
    bimester integer,
    trimester integer,
    quarter integer,
    semester integer
);


ALTER TABLE date_dim OWNER TO postgres;

--
-- TOC entry 779 (class 1259 OID 358040)
-- Name: event_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE event_dim (
    id integer,
    name character varying,
    "time" time without time zone,
    type character varying(255),
    cancelled boolean
);


ALTER TABLE event_dim OWNER TO postgres;

--
-- TOC entry 780 (class 1259 OID 358048)
-- Name: event_fact; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE event_fact (
    id_event integer,
    id_date integer,
    id_artist integer,
    id_area integer,
    place_name character varying
);


ALTER TABLE event_fact OWNER TO postgres;

--
-- TOC entry 781 (class 1259 OID 358056)
-- Name: release_dim; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE release_dim (
    id integer,
    name character varying,
    id_artist_credit integer,
    packaging character varying(255),
    id_area integer,
    id_release_group integer,
    language character varying(100),
    status character varying(255)
);


ALTER TABLE release_dim OWNER TO postgres;

--
-- TOC entry 782 (class 1259 OID 358063)
-- Name: release_fact; Type: TABLE; Schema: pf_datawarehouse; Owner: postgres
--

CREATE TABLE release_fact (
    id_release integer,
    id_date integer,
    id_area integer,
    id_artist_credit integer
);


ALTER TABLE release_fact OWNER TO postgres;

CREATE TABLE pf_datawarehouse.city
(
    id integer,
    name character varying,
    id_country integer
);

CREATE TABLE pf_datawarehouse.country
(
    id integer,
    name character varying 
);

-- Completed on 2018-05-10 18:32:18

--
-- PostgreSQL database dump complete
--

