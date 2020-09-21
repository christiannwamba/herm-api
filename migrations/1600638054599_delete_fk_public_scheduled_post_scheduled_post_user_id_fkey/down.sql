alter table "public"."scheduled_post" add foreign key ("user_id") references "public"."user"("id") on update restrict on delete restrict;
