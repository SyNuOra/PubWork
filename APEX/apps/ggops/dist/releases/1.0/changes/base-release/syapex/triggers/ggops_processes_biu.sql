-- liquibase formatted sql
-- changeset SYAPEX:1771865128666 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_processes_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_processes_biu.sql:null:5b2b80ddf130d72952b190296756b5cad688874f:create

create or replace editionable trigger syapex.ggops_processes_biu before
    insert or update on syapex.ggops_processes
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
end ggops_processes_biu;
/

alter trigger syapex.ggops_processes_biu enable;

