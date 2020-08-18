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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    user_id integer,
    language character varying(4),
    content character varying(100000),
    title character varying(100),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    words_data jsonb DEFAULT '{}'::jsonb
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: external_articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_articles (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying,
    url character varying,
    source character varying,
    author character varying,
    date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_idioms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_idioms (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    value character varying NOT NULL,
    meaning character varying NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_irregular_verbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_irregular_verbs (
    id integer NOT NULL,
    infinitive character varying,
    simple_past jsonb DEFAULT '[]'::jsonb,
    past_participle jsonb DEFAULT '[]'::jsonb
);


--
-- Name: grammar_eng_irregular_verbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grammar_eng_irregular_verbs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grammar_eng_irregular_verbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grammar_eng_irregular_verbs_id_seq OWNED BY public.grammar_eng_irregular_verbs.id;


--
-- Name: grammar_eng_phrasal_verb_meanings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_phrasal_verb_meanings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    value character varying NOT NULL,
    example character varying,
    phrasal_verb_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_phrasal_verbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_phrasal_verbs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    value character varying NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_user_idioms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_user_idioms (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    idiom_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_user_irregular_verbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_user_irregular_verbs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    irregular_verb_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_eng_user_phrasal_verbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grammar_eng_user_phrasal_verbs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    phrasal_verb_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.links (
    sentence_1_id integer NOT NULL,
    sentence_2_id integer NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    message_type integer
);


--
-- Name: mnemos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mnemos (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    word_id integer,
    language character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creative_added boolean DEFAULT false
);


--
-- Name: payment_callbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_callbacks (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sentences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentences (
    id integer NOT NULL,
    language character varying(4),
    value character varying,
    tatoeba_id integer,
    with_audio boolean DEFAULT false
);


--
-- Name: sentences_words; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentences_words (
    word_id integer NOT NULL,
    sentence_id integer NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: skyeng_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skyeng_settings (
    id integer NOT NULL,
    user_id integer,
    aasm_state character varying,
    email character varying NOT NULL,
    token character varying
);


--
-- Name: skyeng_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skyeng_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skyeng_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skyeng_settings_id_seq OWNED BY public.skyeng_settings.id;


--
-- Name: telegram_chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.telegram_chats (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    chat_id bigint NOT NULL,
    username character varying,
    first_name character varying,
    last_name character varying,
    active boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trainings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trainings (
    id integer NOT NULL,
    user_id integer,
    words_learned integer DEFAULT 0 NOT NULL,
    current_page integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data jsonb,
    type character varying
);


--
-- Name: trainings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trainings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trainings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trainings_id_seq OWNED BY public.trainings.id;


--
-- Name: user_authentications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_authentications (
    id integer NOT NULL,
    user_id integer,
    uid character varying,
    token character varying,
    token_expires_at timestamp without time zone,
    params text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider integer
);


--
-- Name: user_authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_authentications_id_seq OWNED BY public.user_authentications.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role smallint DEFAULT 0 NOT NULL,
    native_language smallint,
    learning_language smallint,
    sentences_number smallint DEFAULT 5 NOT NULL,
    audio_enable boolean DEFAULT false,
    diversity_enable boolean DEFAULT false,
    additional_info jsonb DEFAULT '{}'::jsonb,
    promo_email_sent boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: word_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.word_statuses (
    user_id integer,
    word_id integer,
    learned boolean NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: words; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.words (
    id integer NOT NULL,
    language character varying(4),
    value character varying,
    pos character varying,
    weight integer,
    transcription character varying,
    data jsonb
);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: grammar_eng_irregular_verbs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_irregular_verbs ALTER COLUMN id SET DEFAULT nextval('public.grammar_eng_irregular_verbs_id_seq'::regclass);


--
-- Name: skyeng_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skyeng_settings ALTER COLUMN id SET DEFAULT nextval('public.skyeng_settings_id_seq'::regclass);


--
-- Name: trainings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings ALTER COLUMN id SET DEFAULT nextval('public.trainings_id_seq'::regclass);


--
-- Name: user_authentications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_authentications ALTER COLUMN id SET DEFAULT nextval('public.user_authentications_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: external_articles external_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_articles
    ADD CONSTRAINT external_articles_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_idioms grammar_eng_idioms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_idioms
    ADD CONSTRAINT grammar_eng_idioms_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_irregular_verbs grammar_eng_irregular_verbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_irregular_verbs
    ADD CONSTRAINT grammar_eng_irregular_verbs_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_phrasal_verb_meanings grammar_eng_phrasal_verb_meanings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_phrasal_verb_meanings
    ADD CONSTRAINT grammar_eng_phrasal_verb_meanings_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_phrasal_verbs grammar_eng_phrasal_verbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_phrasal_verbs
    ADD CONSTRAINT grammar_eng_phrasal_verbs_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_user_idioms grammar_eng_user_idioms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_idioms
    ADD CONSTRAINT grammar_eng_user_idioms_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_user_irregular_verbs grammar_eng_user_irregular_verbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_irregular_verbs
    ADD CONSTRAINT grammar_eng_user_irregular_verbs_pkey PRIMARY KEY (id);


--
-- Name: grammar_eng_user_phrasal_verbs grammar_eng_user_phrasal_verbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_phrasal_verbs
    ADD CONSTRAINT grammar_eng_user_phrasal_verbs_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: mnemos mnemos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mnemos
    ADD CONSTRAINT mnemos_pkey PRIMARY KEY (id);


--
-- Name: payment_callbacks payment_callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_callbacks
    ADD CONSTRAINT payment_callbacks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sentences sentences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentences
    ADD CONSTRAINT sentences_pkey PRIMARY KEY (id);


--
-- Name: sentences_words sentences_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentences_words
    ADD CONSTRAINT sentences_words_pkey PRIMARY KEY (id);


--
-- Name: skyeng_settings skyeng_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skyeng_settings
    ADD CONSTRAINT skyeng_settings_pkey PRIMARY KEY (id);


--
-- Name: telegram_chats telegram_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telegram_chats
    ADD CONSTRAINT telegram_chats_pkey PRIMARY KEY (id);


--
-- Name: trainings trainings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings
    ADD CONSTRAINT trainings_pkey PRIMARY KEY (id);


--
-- Name: user_authentications user_authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_authentications
    ADD CONSTRAINT user_authentications_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: word_statuses word_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.word_statuses
    ADD CONSTRAINT word_statuses_pkey PRIMARY KEY (id);


--
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- Name: index_articles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_user_id ON public.articles USING btree (user_id);


--
-- Name: index_grammar_eng_idioms_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_grammar_eng_idioms_on_value ON public.grammar_eng_idioms USING btree (value);


--
-- Name: index_grammar_eng_phrasal_verb_meanings_on_phrasal_verb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_phrasal_verb_meanings_on_phrasal_verb_id ON public.grammar_eng_phrasal_verb_meanings USING btree (phrasal_verb_id);


--
-- Name: index_grammar_eng_phrasal_verbs_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_grammar_eng_phrasal_verbs_on_value ON public.grammar_eng_phrasal_verbs USING btree (value);


--
-- Name: index_grammar_eng_user_idioms_on_idiom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_idioms_on_idiom_id ON public.grammar_eng_user_idioms USING btree (idiom_id);


--
-- Name: index_grammar_eng_user_idioms_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_idioms_on_user_id ON public.grammar_eng_user_idioms USING btree (user_id);


--
-- Name: index_grammar_eng_user_idioms_on_user_id_and_idiom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_grammar_eng_user_idioms_on_user_id_and_idiom_id ON public.grammar_eng_user_idioms USING btree (user_id, idiom_id);


--
-- Name: index_grammar_eng_user_irregular_verbs_on_irregular_verb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_irregular_verbs_on_irregular_verb_id ON public.grammar_eng_user_irregular_verbs USING btree (irregular_verb_id);


--
-- Name: index_grammar_eng_user_irregular_verbs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_irregular_verbs_on_user_id ON public.grammar_eng_user_irregular_verbs USING btree (user_id);


--
-- Name: index_grammar_eng_user_phrasal_verbs_on_phrasal_verb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_phrasal_verbs_on_phrasal_verb_id ON public.grammar_eng_user_phrasal_verbs USING btree (phrasal_verb_id);


--
-- Name: index_grammar_eng_user_phrasal_verbs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grammar_eng_user_phrasal_verbs_on_user_id ON public.grammar_eng_user_phrasal_verbs USING btree (user_id);


--
-- Name: index_links_on_sentence_1_id_and_sentence_2_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_links_on_sentence_1_id_and_sentence_2_id ON public.links USING btree (sentence_1_id, sentence_2_id);


--
-- Name: index_mnemos_on_word_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mnemos_on_word_id ON public.mnemos USING btree (word_id);


--
-- Name: index_sentences_on_language; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sentences_on_language ON public.sentences USING btree (language);


--
-- Name: index_sentences_words_on_word_id_and_sentence_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sentences_words_on_word_id_and_sentence_id ON public.sentences_words USING btree (word_id, sentence_id);


--
-- Name: index_skyeng_settings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skyeng_settings_on_user_id ON public.skyeng_settings USING btree (user_id);


--
-- Name: index_telegram_chats_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_telegram_chats_on_user_id ON public.telegram_chats USING btree (user_id);


--
-- Name: index_trainings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainings_on_user_id ON public.trainings USING btree (user_id);


--
-- Name: index_user_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_authentications_on_user_id ON public.user_authentications USING btree (user_id);


--
-- Name: index_user_on_irregular_verb; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_on_irregular_verb ON public.grammar_eng_user_irregular_verbs USING btree (user_id, irregular_verb_id);


--
-- Name: index_user_on_phrasal_verb; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_on_phrasal_verb ON public.grammar_eng_user_phrasal_verbs USING btree (user_id, phrasal_verb_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_word_statuses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_word_statuses_on_user_id ON public.word_statuses USING btree (user_id);


--
-- Name: index_word_statuses_on_user_id_and_word_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_word_statuses_on_user_id_and_word_id ON public.word_statuses USING btree (user_id, word_id);


--
-- Name: index_word_statuses_on_word_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_word_statuses_on_word_id ON public.word_statuses USING btree (word_id);


--
-- Name: index_words_on_language; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_words_on_language ON public.words USING btree (language);


--
-- Name: index_words_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_words_on_value ON public.words USING btree (value);


--
-- Name: grammar_eng_user_idioms fk_rails_134f689978; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_idioms
    ADD CONSTRAINT fk_rails_134f689978 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: grammar_eng_user_irregular_verbs fk_rails_1ddddd9f4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_irregular_verbs
    ADD CONSTRAINT fk_rails_1ddddd9f4b FOREIGN KEY (irregular_verb_id) REFERENCES public.grammar_eng_irregular_verbs(id);


--
-- Name: articles fk_rails_3d31dad1cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_3d31dad1cc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: grammar_eng_user_phrasal_verbs fk_rails_5fde8a6944; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_phrasal_verbs
    ADD CONSTRAINT fk_rails_5fde8a6944 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: grammar_eng_user_phrasal_verbs fk_rails_75eb6993ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_phrasal_verbs
    ADD CONSTRAINT fk_rails_75eb6993ab FOREIGN KEY (phrasal_verb_id) REFERENCES public.grammar_eng_phrasal_verbs(id);


--
-- Name: grammar_eng_user_idioms fk_rails_8dbd4b5a33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_idioms
    ADD CONSTRAINT fk_rails_8dbd4b5a33 FOREIGN KEY (idiom_id) REFERENCES public.grammar_eng_idioms(id);


--
-- Name: grammar_eng_phrasal_verb_meanings fk_rails_da71a9f489; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_phrasal_verb_meanings
    ADD CONSTRAINT fk_rails_da71a9f489 FOREIGN KEY (phrasal_verb_id) REFERENCES public.grammar_eng_phrasal_verbs(id);


--
-- Name: trainings fk_rails_db3101896b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainings
    ADD CONSTRAINT fk_rails_db3101896b FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: telegram_chats fk_rails_e5c49caf7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telegram_chats
    ADD CONSTRAINT fk_rails_e5c49caf7e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: grammar_eng_user_irregular_verbs fk_rails_f4cb81780a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grammar_eng_user_irregular_verbs
    ADD CONSTRAINT fk_rails_f4cb81780a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160608075034'),
('20160608075046'),
('20160608080257'),
('20160610201024'),
('20160610201253'),
('20160612091932'),
('20160612092653'),
('20160621081409'),
('20160621081499'),
('20160721054957'),
('20160721055643'),
('20170509095917'),
('20170520090258'),
('20170520092743'),
('20170520101254'),
('20170520182509'),
('20170629200429'),
('20170629200430'),
('20170715110921'),
('20170722133710'),
('20170929174934'),
('20170929180800'),
('20171003191316'),
('20180303163147'),
('20181231110700'),
('20181231110805'),
('20181231111307'),
('20181231113852'),
('20181231172151'),
('20181231175840'),
('20190104173248'),
('20190105145618'),
('20190106183138'),
('20190829173533'),
('20190831084547'),
('20190831094652'),
('20190831172035'),
('20190920205839'),
('20191008114438'),
('20191130202534'),
('20191130211957'),
('20191130214530'),
('20200624190543'),
('20200624190551'),
('20200707153919'),
('20200707153929'),
('20200707153942'),
('20200707214051'),
('20200726082213'),
('20200812182958');


