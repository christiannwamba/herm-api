alter table "public"."scheduled_post"
           add constraint "scheduled_post_user_id_fkey"
           foreign key ("user_id")
           references "public"."user"
           ("id") on update restrict on delete restrict;
