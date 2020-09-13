ALTER TABLE "public"."scheduled_post" ADD COLUMN "created_at" timestamptz NULL DEFAULT now();
