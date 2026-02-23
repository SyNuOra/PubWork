-- liquibase formatted sql
-- changeset SYAPEX:1771865128381 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_encryption_profiles_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_encryption_profiles_biu.sql:null:f27841f2709197c0807936611c1b0fa93039770c:create

create or replace editionable trigger syapex.ggops_encryption_profiles_biu before
    insert or update on syapex.ggops_encryption_profiles
    for each row
begin
    if inserting then
        :new.created := localtimestamp;
        :new.created_by := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        );
    end if;

    :new.updated := localtimestamp;
    :new.updated_by := coalesce(
        sys_context('APEX$SESSION', 'APP_USER'),
        user
    );
end ggops_encryption_profiles_biu;
/

alter trigger syapex.ggops_encryption_profiles_biu enable;

