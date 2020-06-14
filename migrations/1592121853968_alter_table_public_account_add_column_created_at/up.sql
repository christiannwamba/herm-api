ALTER TABLE "public"."account" ADD COLUMN "created_at" timestamptz NULL DEFAULT now();
