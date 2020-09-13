alter table "public"."scheduled_post" drop constraint "scheduled_post_id_fkey",
             add constraint "scheduled_post_user_id_fkey"
             foreign key ("user_id")
             references "public"."user"
             ("id") on update restrict on delete cascade;
