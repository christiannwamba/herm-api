alter table "public"."scheduled_post" add foreign key ("id") references "public"."user"("id") on update restrict on delete restrict;
