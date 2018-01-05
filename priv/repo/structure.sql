--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bots (
    id uuid NOT NULL,
    installation_id integer,
    name character varying(255),
    owner character varying(255),
    repo_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: gh_repos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gh_repos (
    id uuid NOT NULL,
    owner character varying(255),
    name character varying(255),
    repo_id integer,
    installation_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: bots bots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bots
    ADD CONSTRAINT bots_pkey PRIMARY KEY (id);


--
-- Name: gh_repos gh_repos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gh_repos
    ADD CONSTRAINT gh_repos_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: bots_owner_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bots_owner_name_index ON bots USING btree (owner, name);


--
-- Name: bots_repo_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bots_repo_id_index ON bots USING btree (repo_id);


--
-- Name: gh_repos_owner_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gh_repos_owner_name_index ON gh_repos USING btree (owner, name);


--
-- Name: gh_repos_repo_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gh_repos_repo_id_index ON gh_repos USING btree (repo_id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20171218055104), (20171221195342);

