--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: MedIQ; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "MedIQ";


ALTER SCHEMA "MedIQ" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: discussion_posts; Type: TABLE; Schema: MedIQ; Owner: postgres
--

CREATE TABLE "MedIQ".discussion_posts (
    id integer NOT NULL,
    message character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer NOT NULL,
    post_id integer NOT NULL,
    is_active boolean
);


ALTER TABLE "MedIQ".discussion_posts OWNER TO postgres;

--
-- Name: discussion_posts_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".discussion_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".discussion_posts_id_seq OWNER TO postgres;

--
-- Name: discussion_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".discussion_posts_id_seq OWNED BY "MedIQ".discussion_posts.id;


--
-- Name: discussion_posts_post_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".discussion_posts_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".discussion_posts_post_id_seq OWNER TO postgres;

--
-- Name: discussion_posts_post_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".discussion_posts_post_id_seq OWNED BY "MedIQ".discussion_posts.post_id;


--
-- Name: discussion_posts_user_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".discussion_posts_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".discussion_posts_user_id_seq OWNER TO postgres;

--
-- Name: discussion_posts_user_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".discussion_posts_user_id_seq OWNED BY "MedIQ".discussion_posts.user_id;


--
-- Name: discussions; Type: TABLE; Schema: MedIQ; Owner: postgres
--

CREATE TABLE "MedIQ".discussions (
    id integer NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    message text NOT NULL,
    owner_id integer NOT NULL,
    group_id integer NOT NULL,
    is_active boolean
);


ALTER TABLE "MedIQ".discussions OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: MedIQ; Owner: postgres
--

CREATE TABLE "MedIQ".groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    creator_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description character varying
);


ALTER TABLE "MedIQ".groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".groups_id_seq OWNED BY "MedIQ".groups.id;


--
-- Name: newtable_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".newtable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".newtable_id_seq OWNER TO postgres;

--
-- Name: newtable_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".newtable_id_seq OWNED BY "MedIQ".discussions.id;


--
-- Name: newtable_owner_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".newtable_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".newtable_owner_id_seq OWNER TO postgres;

--
-- Name: newtable_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".newtable_owner_id_seq OWNED BY "MedIQ".discussions.owner_id;


--
-- Name: reactions; Type: TABLE; Schema: MedIQ; Owner: postgres
--

CREATE TABLE "MedIQ".reactions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    reaction character varying NOT NULL,
    post_id integer NOT NULL,
    reacted_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reaction_type_check CHECK ((((reaction)::text = 'LIKE'::text) OR ((reaction)::text = 'DISLIKE'::text) OR ((reaction)::text = 'HEART'::text) OR ((reaction)::text = 'HAHA'::text) OR ((reaction)::text = 'SUPPORT'::text)))
);


ALTER TABLE "MedIQ".reactions OWNER TO postgres;

--
-- Name: reactions_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".reactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".reactions_id_seq OWNER TO postgres;

--
-- Name: reactions_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".reactions_id_seq OWNED BY "MedIQ".reactions.id;


--
-- Name: users; Type: TABLE; Schema: MedIQ; Owner: postgres
--

CREATE TABLE "MedIQ".users (
    id integer NOT NULL,
    email character varying NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    privileges character varying DEFAULT USER NOT NULL,
    CONSTRAINT privileges_check CHECK ((((privileges)::text = 'ADMIN'::text) OR ((privileges)::text = 'MODERATOR'::text) OR ((privileges)::text = 'USER'::text)))
);


ALTER TABLE "MedIQ".users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: MedIQ; Owner: postgres
--

CREATE SEQUENCE "MedIQ".users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "MedIQ".users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: MedIQ; Owner: postgres
--

ALTER SEQUENCE "MedIQ".users_id_seq OWNED BY "MedIQ".users.id;


--
-- Name: discussion_posts id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussion_posts ALTER COLUMN id SET DEFAULT nextval('"MedIQ".discussion_posts_id_seq'::regclass);


--
-- Name: discussions id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussions ALTER COLUMN id SET DEFAULT nextval('"MedIQ".newtable_id_seq'::regclass);


--
-- Name: discussions owner_id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussions ALTER COLUMN owner_id SET DEFAULT nextval('"MedIQ".newtable_owner_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".groups ALTER COLUMN id SET DEFAULT nextval('"MedIQ".groups_id_seq'::regclass);


--
-- Name: reactions id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".reactions ALTER COLUMN id SET DEFAULT nextval('"MedIQ".reactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".users ALTER COLUMN id SET DEFAULT nextval('"MedIQ".users_id_seq'::regclass);


--
-- Data for Name: discussion_posts; Type: TABLE DATA; Schema: MedIQ; Owner: postgres
--

COPY "MedIQ".discussion_posts (id, message, created_at, updated_at, user_id, post_id, is_active) FROM stdin;
11	Resposta aos amiguinhos!	2024-10-11 01:42:30.186	2024-10-11 01:42:30.186	9	5	t
13	Resposta dada, amiguinhos!!! [redacted]	2024-10-11 01:42:38.955	2024-10-11 05:12:32.984	9	5	t
14	Resposta aos amiguinhos! Vai dar tudo certo!	2024-10-11 04:11:40.857	2024-10-11 06:00:55.5	9	5	f
15	Discordo	2024-10-16 13:17:49.631	2024-10-16 13:17:49.631	9	7	t
\.


--
-- Data for Name: discussions; Type: TABLE DATA; Schema: MedIQ; Owner: postgres
--

COPY "MedIQ".discussions (id, title, created_at, updated_at, message, owner_id, group_id, is_active) FROM stdin;
6	título	2024-10-11 06:03:52.212	2024-10-11 06:09:08.192	Post do moderador aqui amigos	36	1	f
5	título	2024-10-11 01:30:53.707	2024-10-14 14:38:48.23	boa tarde amigos	9	1	t
7	título	2024-10-16 13:17:15.777	2024-10-16 13:17:15.777	Post do user aqui amigos	38	5	t
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: MedIQ; Owner: postgres
--

COPY "MedIQ".groups (id, name, updated_at, created_at, creator_id, is_active, description) FROM stdin;
1	Hematologia	2024-10-10 23:36:22.046	2024-10-10 23:36:22.046	9	t	\N
2	Pediatria	2024-10-16 13:12:39.464	2024-10-16 13:12:39.464	37	t	\N
3	Pediatria	2024-10-16 13:13:23.355	2024-10-16 13:13:23.355	37	t	\N
4	Pediatria	2024-10-16 13:13:42.089	2024-10-16 13:13:42.089	37	t	\N
5	Dermatologia	2024-10-16 13:14:39.039	2024-10-16 13:14:39.039	37	t	\N
\.


--
-- Data for Name: reactions; Type: TABLE DATA; Schema: MedIQ; Owner: postgres
--

COPY "MedIQ".reactions (id, user_id, reaction, post_id, reacted_at) FROM stdin;
6	9	LIKE	11	2024-10-15 13:03:18.812154
7	2	LIKE	11	2024-10-15 13:03:18.812154
8	36	HAHA	11	2024-10-15 13:03:18.812154
9	37	DISLIKE	11	2024-10-15 13:03:18.812154
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: MedIQ; Owner: postgres
--

COPY "MedIQ".users (id, email, username, password, created_at, updated_at, is_active, privileges) FROM stdin;
4	errricc@santos	errricc	erricc	2024-10-10 01:05:00	2024-10-10 01:05:00	t	USER
9	ericsantosbr2@gmail.com	eric	$2b$12$d.RopP398Tc31ZA7ViuXHOZMRIY.CEeDuDrHXUp1EzL0noUl7.7aO	2024-10-10 05:16:26.992	2024-10-10 05:16:26.992	t	USER
36	moderator@user	moderator	$2b$12$PI2DLMgdmlsYanHfWhTV6.QEGb6PPmX2umBVqx5Sdholy41oZKJmO	2024-10-11 05:08:53.886	2024-10-11 05:08:53.886	t	MODERATOR
2	ericc@santos	ericc	ericc	2024-10-10 01:05:00	2024-10-10 01:05:00	t	USER
37	admin@user	admin	$2b$12$9FZkM5c7BbO0HFXn0FL9.emCbRIk8qF6c0Fol7jAJiH6tPGY5eMGy	2024-10-11 13:35:59.058	2024-10-11 13:35:59.058	t	ADMIN
1	eric@santos	ericsantos	1234	2024-10-10 01:05:00	2024-10-11 13:37:07.07	t	USER
3	erricc@santos	erricc	ericc	2024-10-10 01:05:00	2024-10-11 13:38:55.119	t	USER
38	novo@usuario	novousuario	$2b$12$nZKz7il2afZMtvEZidIEzOM8/kQO1gQe6K8HrfMjo6Wvp2FJOMggS	2024-10-16 00:42:52.586	2024-10-16 00:42:52.586	t	USER
\.


--
-- Name: discussion_posts_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".discussion_posts_id_seq', 15, true);


--
-- Name: discussion_posts_post_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".discussion_posts_post_id_seq', 4, true);


--
-- Name: discussion_posts_user_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".discussion_posts_user_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".groups_id_seq', 5, true);


--
-- Name: newtable_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".newtable_id_seq', 7, true);


--
-- Name: newtable_owner_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".newtable_owner_id_seq', 1, false);


--
-- Name: reactions_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".reactions_id_seq', 31, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: MedIQ; Owner: postgres
--

SELECT pg_catalog.setval('"MedIQ".users_id_seq', 38, true);


--
-- Name: discussion_posts discussion_posts_pk; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussion_posts
    ADD CONSTRAINT discussion_posts_pk PRIMARY KEY (id);


--
-- Name: groups groups_pk; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".groups
    ADD CONSTRAINT groups_pk PRIMARY KEY (id);


--
-- Name: discussions newtable_pk; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussions
    ADD CONSTRAINT newtable_pk PRIMARY KEY (id);


--
-- Name: reactions reactions_pk; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".reactions
    ADD CONSTRAINT reactions_pk PRIMARY KEY (id);


--
-- Name: reactions reactions_unique; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".reactions
    ADD CONSTRAINT reactions_unique UNIQUE (user_id, post_id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: users users_unique; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".users
    ADD CONSTRAINT users_unique UNIQUE (email);


--
-- Name: users users_unique_1; Type: CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".users
    ADD CONSTRAINT users_unique_1 UNIQUE (username);


--
-- Name: discussion_posts discussion_posts_discussions_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussion_posts
    ADD CONSTRAINT discussion_posts_discussions_fk FOREIGN KEY (post_id) REFERENCES "MedIQ".discussions(id);


--
-- Name: discussion_posts discussion_posts_users_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussion_posts
    ADD CONSTRAINT discussion_posts_users_fk FOREIGN KEY (user_id) REFERENCES "MedIQ".users(id);


--
-- Name: discussions discussions_groups_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussions
    ADD CONSTRAINT discussions_groups_fk FOREIGN KEY (group_id) REFERENCES "MedIQ".groups(id);


--
-- Name: groups groups_users_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".groups
    ADD CONSTRAINT groups_users_fk FOREIGN KEY (creator_id) REFERENCES "MedIQ".users(id);


--
-- Name: discussions newtable_users_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".discussions
    ADD CONSTRAINT newtable_users_fk FOREIGN KEY (owner_id) REFERENCES "MedIQ".users(id);


--
-- Name: reactions reactions_discussion_posts_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".reactions
    ADD CONSTRAINT reactions_discussion_posts_fk FOREIGN KEY (post_id) REFERENCES "MedIQ".discussion_posts(id);


--
-- Name: reactions reactions_users_fk; Type: FK CONSTRAINT; Schema: MedIQ; Owner: postgres
--

ALTER TABLE ONLY "MedIQ".reactions
    ADD CONSTRAINT reactions_users_fk FOREIGN KEY (user_id) REFERENCES "MedIQ".users(id);


--
-- PostgreSQL database dump complete
--

