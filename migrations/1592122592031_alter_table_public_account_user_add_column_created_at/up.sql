ALTER TABLE "public"."account_user" ADD COLUMN "created_at" timestamptz NULL DEFAULT now();
