CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.account (
    account_name text NOT NULL,
    access_token text NOT NULL,
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    access_token_secret text
);
CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;
CREATE TABLE public.account_user (
    account_id integer NOT NULL,
    user_id integer NOT NULL,
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.account_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.account_user_id_seq OWNED BY public.account_user.id;
CREATE TABLE public.scheduled_post (
    id integer NOT NULL,
    text text NOT NULL,
    schedule_for timestamp with time zone NOT NULL,
    is_pending boolean DEFAULT true NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.scheduled_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.scheduled_post_id_seq OWNED BY public.scheduled_post.id;
CREATE TABLE public."user" (
    username text NOT NULL,
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;
ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);
ALTER TABLE ONLY public.account_user ALTER COLUMN id SET DEFAULT nextval('public.account_user_id_seq'::regclass);
ALTER TABLE ONLY public.scheduled_post ALTER COLUMN id SET DEFAULT nextval('public.scheduled_post_id_seq'::regclass);
ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_account_name_key UNIQUE (account_name);
ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT account_user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.scheduled_post
    ADD CONSTRAINT scheduled_post_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT account_user_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT account_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.scheduled_post
    ADD CONSTRAINT scheduled_post_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
