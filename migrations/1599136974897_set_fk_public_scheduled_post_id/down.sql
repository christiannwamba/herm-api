alter table "public"."scheduled_post" drop constraint "scheduled_post_id_fkey",
          add constraint "scheduled_post_id_fkey"
          foreign key ("id")
          references "public"."account_user"
          ("id")
          on update restrict
          on delete cascade;
