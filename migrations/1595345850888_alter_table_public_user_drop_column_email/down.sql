ALTER TABLE "public"."user" ADD COLUMN "email" text;
ALTER TABLE "public"."user" ALTER COLUMN "email" DROP NOT NULL;
ALTER TABLE "public"."user" ADD CONSTRAINT user_email_key UNIQUE (email);
