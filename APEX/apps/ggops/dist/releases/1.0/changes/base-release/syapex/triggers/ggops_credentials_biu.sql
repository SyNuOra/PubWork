-- liquibase formatted sql
-- changeset SYAPEX:1771865128246 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_credentials_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_credentials_biu.sql:null:ad1a7b18c742063a922f5dae2fbb468932b7214c:create

create or replace editionable trigger syapex.ggops_credentials_biu before
    insert or update on syapex.ggops_credentials
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
end ggops_credentials_biu;
/

alter trigger syapex.ggops_credentials_biu enable;

