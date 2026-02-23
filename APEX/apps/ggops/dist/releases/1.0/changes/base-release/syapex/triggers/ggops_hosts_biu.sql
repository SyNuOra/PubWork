-- liquibase formatted sql
-- changeset SYAPEX:1771865128450 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_hosts_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_hosts_biu.sql:null:d471b4c27b351d07f5bcba1a2ea9595e3b5bcb42:create

create or replace editionable trigger syapex.ggops_hosts_biu before
    insert or update on syapex.ggops_hosts
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
end ggops_hosts_biu;
/

alter trigger syapex.ggops_hosts_biu enable;

